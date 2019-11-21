# encoding: UTF-8

require_relative "interactor"

module Clerq
  module Interactors

    class QueryTemplate < Interactor

      private_class_method :new

      def call
        Clerq.text_repository.text(@template)
      rescue StandardError
        err = "'#{@template}' template not found!"
        raise Failure, err
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
