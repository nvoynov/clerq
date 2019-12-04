# encoding: UTF-8

require_relative "service"

module Clerq
  module Services

    # Provides repository nodes assembly
    # @param [Sring] optional query string
    # @return [Node] assembly of repository nodes
    #
    # Usage
    #   QueryAssembly.(asse:, query:)
    #   QueryAssembly.(query_string)
    #
    # Rules for root node:
    #   when query not passed, it return the whole hierarchy
    #   when nodes not found, it returns empty root node with meta[:query]
    #   when query returns one single node, it returns this node
    #   when query returns mare than one nodes, then
    #     * it creates empty root node with meta[:query]
    #     * and places found nodes to the root
    class QueryNode < Service

      def call
        proc = prepare_query unless @query.empty?

        arry = @assembly.select{|node| proc.call(node) }
        return arry.first.orphan! if arry.size == 1

        node = Node.new(title: Clerq.title, meta: {query: @query})
        arry.each{|n| node << n.orphan!}
        node
      end

      protected

      def initialize(assembly: , query: )
        unless assembly.is_a? Node
          msg = "Invailid argument 'assembly'"
          raise ArgumentError, msg
        end
        unless query.is_a? String
          msg = "Invailid argument 'query'"
          raise ArgumentError, msg
        end
        @query = query
        @assembly = assembly
      end

      def prepare_query
        proc = Proc.new{|node| eval(@query)}
        Node.new.select{|node| proc.call(node)}
        proc
      rescue Exception => e
        msg = "Invalid query format #{@query} (#{e.message})\n#{USAGE}"
        raise ArgumentError, msg
      end

      USAGE = <<~EOF
        QueryAssembly.call(query: ) evaluates query paramater
        by eval() as 'Proc.new { |node| eval(query) }'
        e.g. the followed queries are valid:
          node.id == 'uc'
          node.title == 'Introduction'
          node[:originator] == 'clerq'
      EOF

    end

  end
end
