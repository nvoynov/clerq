# encoding: UTF-8

require_relative "interactor"
require_relative "query_template"

module Clerq
  module Interactors

    # Creates new node in repository according to provided parameters
    # or raises CreateNode::Failure when
    #   * template not found
    #   * or repository contains a node with the same id
    class CreateNode < Interactor

      def call
        @body = QueryTemplate.(@template) if @body.empty? && !@template.empty?
        @node = Clerq::Entities::Node.new(
          id: @id, title: @title, body: @body, meta: @meta)
        Clerq.node_repository.save(@node)
      rescue StandardError => e
        raise Failure, e.message
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
