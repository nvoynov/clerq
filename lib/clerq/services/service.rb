# encoding: UTF-8

module Clerq
  module Services

    class Service
      def self.call(*args)
        new(*args).call
      end

      private_class_method :new

      # Should be implemented in subclasses
      def call
      end
    end

  end
end
