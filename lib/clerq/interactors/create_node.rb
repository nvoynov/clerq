# encoding: UTF-8

require_relative "interactor"

module Clerq
  module Interactors

    class CreateNode < Interactor

      def call
        unless @template.empty?
          tt = gateway.templates(@template)
          raise Failure, "Template not found" unless tt
# TODO not just `@body = tt.body` but build `@body` in accordance with tt.body
          @body = tt.body
        end
        node = Clerq::Entities::Node.new(
          id: @id, title: @title, body: @body, meta: @meta)
        gateway.save(node)
      end

      protected

      def initialize(id: '', title: '', body: '', meta: {}, template: '')
        raise ArgumentError, "Invalid argument :id" unless id.is_a? String
        raise ArgumentError, "Invalid argument :title" unless title.is_a? String
        raise ArgumentError, "Invalid argument :body" unless body.is_a? String
        raise ArgumentError, "Invalid argument :meta" unless meta.is_a? Hash
        raise ArgumentError, "Invalid argument :template" unless template.is_a? String
        @id = id
        @title = title
        @body = body
        @meta = meta
        @template = template
      end

    end

  end
end
