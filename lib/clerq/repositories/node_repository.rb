# encoding: UTF-8

require_relative '../entities'
require_relative 'repository'
include Clerq::Entities

module Clerq
  module Repositories

    class NodeRepository < Repository
      def initialize(path = Dir.pwd)
        @path = path
        @items = []
      end

      def items(id = nil)
        load_nodes if @items.empty?
        return @items.find {|i| i.id == id} if id
        @items
      end

      def save(node)
        raise ArgumentError, "Invalid argument" unless node.is_a? Node
        Dir.chdir(@path){ File.write(node.id + '.md', markdown(node))}
      end

      protected

        def load_nodes
          @items = []
          Dir.chdir(@path) do
            Dir.glob('**/*.md').each do |f|
              # TODO: what to do with errors?
              nodes = NodeReader.(f)
              nodes.each{|n| @items << n}
            end
          end
        end

        def markdown(n)
          [].tap do |out|
            out << "#{'#' * (n.nesting_level + 1)} [#{n.id}] #{n.title}"
            unless n.meta.empty?
              out << '{{'
              n.meta.each{|k,v| out << "#{k}: #{v}"}
              out << '}}'
              out << "\n"
            end
            out << n.body
          end.join("\n")
        end

    end

  end
end
