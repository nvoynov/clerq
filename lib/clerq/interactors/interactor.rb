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

      protected

        def gateway
          Clerq.gateway
        end
    end

  end
end
