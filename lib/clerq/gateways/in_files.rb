# encoding: UTF-8

require "forwardable"
require_relative '../repositories'
require_relative 'gateway'

module Clerq
  module Gateways

    class InFiles < Gateway
      extend Forwardable

      attr_reader :node_repo, :tplt_repo

      def_delegator :@node_repo, :items, :nodes
      def_delegator :@tplt_repo, :items, :templates

      def initialize
        settings = Clerq.settings
        @node_repo = Clerq::Repositories::NodeRepository.new(settings.src)
        @tplt_repo = Clerq::Repositories::TemplateRepository.new(settings.tt)
        @repositories = {}
        @repositories[Clerq::Entities::Node] = @node_repo
        @repositories[Clerq::Entities::Template] = @tplt_repo
      end

      def save(obj)
        repo = @repositories[obj.class]
        raise ArgumentError, "Repository for #{obj.class} not found" unless repo
        repo.save(obj)
      end

    end

  end
end
