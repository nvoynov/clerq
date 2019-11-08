# encoding: UTF-8

require_relative "interactor"
require_relative "join_nodes"
require_relative "query_nodes"

module Clerq
  module Interactors

    class CompileNodes < Interactor

      # @return [String] document body
      def call
        tt = gateway.templates(@template)
        raise Failure, "Template '#{@template}' not found" unless tt
        node = @query.empty? ? JoinNodes.() : QueryNodes.(query: @query)
        Clerq::Templater.(tt.body, node)
      end

      protected

        def initialize(template:, query: '')
          raise ArgumentError, "Invalid argument :query" unless query.is_a? String
          raise ArgumentError, "Invalid argument :template" if !(template.is_a?(String) && !template.empty?)
          @query = query
          @template = template
        end
    end

  end
end
