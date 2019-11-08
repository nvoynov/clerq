# encoding: UTF-8

require_relative "interactor"
require_relative "join_nodes"

module Clerq
  module Interactors

    class QueryNodes < Interactor

      def call
        proc = prepare_query
        join = JoinNodes.()
        list = join.select{|node| proc.call(node)}
        return Node.new(title: "#{Clerq.settings.title}. Query: #{@query}") if list.empty?
        make_response(list)
      end

      protected

      def initialize(query:)
        raise ArgumentError, "Invalid argument :query" if !(query.is_a?(String) && !query.empty?)
        @query = query
      end

      def prepare_query
        proc = Proc.new {|node| eval(@query)}
        test = Node.new
        test.select{|node| proc.call(node)}
        proc
      rescue Exception => e
        msg = <<~EOF
        Invalid query #{@query} (#{e.message})
        It must eval as 'Proc.new{|node| eval(<query>)}'
        Valid query examples are following:
        node.id == 'uc'
        node.belong?('uc')
        node.belong?('ud') && node[:source] == 'sales'
        EOF
        raise self.class::Failure, msg
      end

      # @param nodes [Array<Node>] result of node.select
      # @return [Node] node that includes all selected nodes
      def make_response(nodes)
        if nodes.size == 1
          node = nodes.first
          node.orphan!
          return node
        end
        Node.new(id: @query).tap{|node|
          nodes.each{|n|
            n.orphan!
            node << n
          }
        }
      end

    end

  end
end
