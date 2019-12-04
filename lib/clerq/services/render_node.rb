# encoding: UTF-8
require_relative 'service'
require_relative 'query_template'
require_relative 'render_erb'

module Clerq
  module Services

    class RenderNode < Service

      def call
        @erb = QueryTemplate.(@ett)
        RenderErb.(erb: @erb, object: @node)
      end

      def initialize(node: , template:)
        check_string_argument!(template, 'template')
        check_string_empty!(template, 'template')
        @node = node
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
