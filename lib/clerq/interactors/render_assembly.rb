# encoding: UTF-8
require_relative 'interactor'
require_relative '../render_erb'

module Clerq
  module Interactors

    class RenderAssembly < Interactor

      def call
        @erb = QueryTemplate.(@ett)
        asmb = QueryAssembly.(@qry)
        RenderErb.(erb: @erb, object: asmb)
        # TODO Clerq.binaries.save(@out, text)
      rescue StandardError => e
        raise Failure, e.message
      end

      def initialize(template:, query: '')
        check_string_argument!(template, 'template')
        check_string_empty!(template, 'template')
        check_string_argument!(query, 'query')
        @qry = query
        @ett = template
      end

      def check_string_argument!(arg, str)
        return if arg.is_a? String
        errmsg = ":#{str} must be String!"
        raise ArgumentError, errmsg, caller
      end

      def check_string_empty!(arg, str)
        return unless arg.empty?
        errmsg = ":#{str} cannot be empty!"
        raise ArgumentError, errmsg, caller
      end
    end

  end
end
