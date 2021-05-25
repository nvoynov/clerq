# encoding: UTF-8

module Clerq
  module Services

    class Service
      def self.call(*args, **opts)
        new(*args, **opts).call
      end

      private_class_method :new

      # Should be implemented in subclasses
      def call
      end
    end

  end
end
