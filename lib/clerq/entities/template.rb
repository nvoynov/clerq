# encoding: UTF-8

module Clerq
  module Entities

    class Template
      attr_reader :id
      attr_reader :body

      def initialize(id:, body: '')
        raise ArgumentError, "Invalid argument :id" if !(id.is_a?(String) && !id.empty?)
        raise ArgumentError, "Invalid argument :body" unless body.is_a? String
        @id = id
        @body = body
      end
    end

  end
end
