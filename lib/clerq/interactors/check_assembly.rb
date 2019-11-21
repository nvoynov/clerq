# encoding: UTF-8

require_relative "interactor"

module Clerq
  module Interactors

    class CheckAssembly < Interactor

      def call
        @node = Clerq.node_repository.assemble
        {}.tap do |errors|
          nonuniq = nonuniq_ids
          errors.merge!(nonuniq_ids: nonuniq) if !nonuniq.empty?
          parents = unknown_parents
          errors.merge!(unknown_parents: parents) if !parents.empty?
          references = unknown_references
          errors.merge!(unknown_references: references) if !references.empty?
          order = unknown_order_index
          errors.merge!(unknown_order_index: order) if !order.empty?
        end
      end

      protected

      # @return [Hash<node id, Array<file_name>>] node ids and array of file_names
      def nonuniq_ids
        @node.each_with_object({}){|node, hsh|
          hsh[node.id] ||= []
          # TODO that way CheckNodes depends on files!?
          hsh[node.id] << node[:file_name]
        }.select{|k, v| v.size > 1}
        .each{|k, v| v.uniq!}
      end

      # @return [Hash<parent, Array<node id>>] unknown meta[:parent] and
      #   array of nodes those have this meta attribute
      def unknown_parents
        @node # .drop(1)?
        .select{|node| node[:parent] && node.parent.id != node[:parent]}
        .each_with_object({}){|node, hsh|
          hsh[node[:parent]] ||= []
          hsh[node[:parent]] << node.id
        }
      end

      # @return [Hash<node_id, Array<node_id>>] node ids that noe found
      #   in hierarchy and array of node ids those have links to corresponding
      #   unknown node
      def unknown_references
        index = @node.map(&:id).drop(1)
        @node.each_with_object({}) do |node, hsh|
          node.links
          .reject {|lnk| index.include?(lnk)}
          .each do |lnk|
            hsh[lnk] ||= []
            hsh[lnk] << node.id
          end
        end
      end

      # @return [Hash<node_id, Array<node_id>>] node ids and array of
      #   unknown links in :order_index
      def unknown_order_index
        @node
        .select{|node| node[:order_index]}
        .each_with_object({}){|node, hsh|
          order = node[:order_index].split(/ /)
          wrong = order.select{|o| node.item(o).nil?}
          hsh[node.id] = wrong unless wrong.empty?
        }
      end

    end

  end
end
