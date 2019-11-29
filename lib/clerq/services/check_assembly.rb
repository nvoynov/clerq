# encoding: UTF-8

require_relative 'service'

module Clerq
  module Services

    # Find errors in hierarchy and prints in console
    class CheckAssembly < Service

      private_class_method :new

      def call
        print_nonuniq_id
        print_lost_roots
        print_lost_index
        print_lost_links
      end

      protected

      def nonuniq_id
        @node.inject({}) do |memo, node|
          memo[node.id] ||= []
          memo[node.id] << node
          memo
        end.select{|_, v| v.size > 1}
      end

      def print_nonuniq_id
        errors = nonuniq_id
        print "Checking for duplicates in node ids... "
        puts errors.empty? ? 'OK' : "#{errors.size} found"
        errors.each do |id, nodes|
          occs = nodes.map{|n| n[:file_name]}
            .group_by{|i| i}
            .map{|k,v| [v.size, k]}
            .sort{|a, b| b.first <=> a.first}
            .map{|i| n, src = i; "#{how_many_times(n)} in '#{src}'"}
          occurrences = occs.join(occs.size == 2 ? ' and ' : ', ')
          puts "- [#{id}] occured #{occurrences}"
        end
      end

      def print_lost_roots
        lost = @node.select{|n| n[:parent] && n.parent.id != n[:parent]}
        print "Checking for lost roots in node parents... "
        puts lost.empty? ? 'OK' : "#{lost.size} found"
        lost.each do |n|
          puts "- {{parent: #{n[:parent]}}} of '#{n.id}' in '#{n[:file_name]}'"
        end
      end

      def print_lost_index
        errors = @node
          .reject{|n| n.order_index.empty?}
          .inject({}) do |memo, n|
            lost = n.order_index.reject{|o| n.item(o)}
            memo[n] = lost unless lost.empty?
            memo
          end

        print "Checking for lost childs in order_index... "
        puts errors.empty? ? 'OK' : "#{errors.size} found"
        errors.each do |n, lost|
          puts "- {{order_index: #{lost.join(' ')}}} not found of node '#{n.id}' in '#{n[:file_name]}'"
        end
      end

      def lost_links
        index = @node.map(&:id).drop(1).uniq
        @node.inject({}) do |memo, node|
          node.links
            .reject{ |lnk| index.include?(lnk) || @node.node(lnk)}
            .each do |lnk|
              memo[lnk] ||= []
              memo[lnk] << node
            end
          memo
        end
      end

      def print_lost_links
        errors = lost_links
        print "Checking for lost links in nodes body... "
        puts errors.empty? ? 'OK' : "#{errors.size} found"
        errors.each do |link, arry|
          where = arry.map{|n| "[#{n.id}] of '#{n[:file_name]}'"}.join(', ')
          puts "- [[#{link}]] in #{where}"
        end
      end

      # humanize number of how many times the error occurred in one file
      def how_many_times(n)
        case n
        when 1 then 'once'
        when 2 then 'twice'
        else "#{n} times"
        end
      end

      def initialize(node)
        @node = node
      end
    end

  end
end
