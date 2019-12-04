# encoding: UTF-8

require_relative "service"

module Clerq
  module Services

    class QueryTemplate < Service

      def call
        Clerq.text_repository.text(@template)
      end

      # @param template [String] required name of template
      def initialize(template)
        if !(template.is_a?(String) && !template.empty?)
          msg = "Invailid argument 'template'"
          raise ArgumentError, msg
        end
        @template = template
      end

    end

  end
end
