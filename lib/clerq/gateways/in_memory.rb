# encoding: UTF-8

require "forwardable"
require_relative "gateway"
require_relative "../repositories/in_memory"

module Clerq
  module Gateways

    class InMemory < Gateway
      extend Forwardable

      attr_reader :node_repo, :template_repo

      def_delegator :@node_repo, :items, :nodes
      def_delegator :@template_repo, :items, :templates

      def initialize
        @node_repo = Clerq::Repositories::InMemory.new
        @template_repo = Clerq::Repositories::InMemory.new
        @repositories = {}
        @repositories[Clerq::Entities::Node] = @node_repo
        @repositories[Clerq::Entities::Template] = @template_repo
      end

      def save(obj)
        repo = @repositories[obj.class]
        raise ArgumentError, "Repository for #{obj.class} not found" unless repo
        repo.save(obj)
      end

    end

  end
end
