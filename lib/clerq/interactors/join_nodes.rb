# encoding: UTF-8

require_relative "interactor"

module Clerq
  module Interactors

    # Combine all nodes in one root node (document)
    class JoinNodes < Interactor

      # @return [Node]
      def call
        @node = join(gateway.nodes)
        subordinate!
        equip_ident!
        @node
      end

      protected

      def join(nodes)
        return nodes.first if nodes.size == 1
        node = Clerq::Entities::Node.new(id: 'join', title: Clerq.settings.title)
        node.tap{|node| nodes.each{|n| node << n}}
      end

      def subordinate!
        @node.items
        .select{|n| n[:parent] && n[:parent] != n.parent.id}
        .each{|n|
          parent = @node.node(n[:parent])
          next unless parent
          parent << n
          @node.items.delete(n)
          n.meta.delete(:parent)
        }
        if @node.id == 'join' && @node.items.size == 1
          @node = @node.items.first
          @node.orphan!
        end
      end

      # equips nodes with autogenerated id
      # @param [Node] node
      def equip_ident!
        counter = {}
        @node.select{|n| n.id.empty?}.each do |n|
          next if n == @node
          index = counter[n.parent] || 1
          counter[n.parent] = index + 1
          id = index.to_s.rjust(2, '0')
          id = '.' + id unless n.parent == @node
          n.id = id
        end
      end

    end
  end
end
