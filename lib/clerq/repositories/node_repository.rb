# encoding: UTF-8

require_relative '../entities'
require_relative 'file_repository'
require_relative 'node_reader'
include Clerq::Entities

module Clerq
  module Repositories

    class NodeRepository < FileRepository

      def initialize(path: Dir.pwd, pattern: '*.md')
        super(path: path, pattern: pattern)
      end

      def save(node)
        check! node
        write("#{node.id}.md", markup(node))
      end

      # asseble repository nodes hierarchy
      # @return [Node]
      def assemble
        @node = Node.new(id: 'join', title: Clerq.title)
        loadn = load
        loadn.each{|n| @node << n}
        subo!
        eqid!
        if @node.items.size == 1
          @node = @node.items.first
          @node.orphan!
        end
        @node
      end

      protected

      def load
        inside do
          [].tap do |ary|
            glob.each do |file|
              # TODO: what to do with errors?
              tmp = NodeReader.(file)
              tmp.each{|node| ary << node }
            end
          end
        end
      end

      def subo!
        @node.items
          .select{|n| n[:parent] && n[:parent] != n.parent.id}
          .each{|n|
            parent = @node.node(n[:parent])
            next unless parent
            parent << n
            @node.items.delete(n)
            n.meta.delete(:parent)
          }
      end

      def eqid!
        counter = {}
        @node.select{|n| n.id.empty?}.each do |n|
          # TODO maybe just .to_a.drop(1).select ?
          next if n == @node
          index = counter[n.parent] || 1
          counter[n.parent] = index + 1
          id = index.to_s.rjust(2, '0')
          id = '.' + id unless n.parent == @node
          n.id = id
        end
      end

      def check!(node)
        return if node.is_a? Node
        errmsg = "Invalid argument"
        raise ArgumentError, errmsg, caller #caller[1..-1]
      end

      def markup(n)
        head = "# [#{n.id}] #{n.title}"
        meta = n.meta.empty? ? '' : n.meta
          .map{|k,v| "#{k}: #{v}"}
          .unshift("{{")
          .push("}}")
          .join("\n")
        [head].tap do |txt|
          txt << "\n#{meta}" unless meta.empty?
          txt << "\n\n#{n.body}" unless n.body.empty?
        end.join + "\n"
      end
    end

  end
end
