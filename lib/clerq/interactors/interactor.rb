# encoding: UTF-8

module Clerq
  module Interactors

    class Interactor
      Failure = Class.new(StandardError)

      def self.inherited(klass)
        klass.const_set(:Failure, Class.new(klass::Failure))
      end

      def self.call(*args)
        new(*args).call
      end

      # Should be implemented in subclasses
      def call; end

      # TODO Suppress ability to create new object
      # private_class_method :new

    end

  end
end
