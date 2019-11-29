# encoding: UTF-8
require "forwardable"

module Clerq
  module Entities

    # The basic block of hierarchy and the single Clerq entity
    #
    # Usage
    #   n = Node.new(title: 'Part I')
    #   n << Node.new(title: 'Item 1')
    #   n << Node.new(title: 'Item 2')
    #   n.each{|i| puts i.tile} # and all power of Enumerable
    class Clerq::Entities::Node
      extend Forwardable
      include Enumerable

      # @!attribute [r] parent
      #   @return [Node] the parent of the node
      attr_reader :parent
      # @!attribute [r] title
      #   @return [String] the title of the node
      attr_reader :title

      # @!attribute [r] body
      #   @return [String] the body of the node
      attr_reader :body

      # @!attribute [r] meta
      #   @return [Hash<Symbol, String>] the metadata of the node
      attr_reader :meta

      # @!attribute [w] id
      #   @return [Hash<Symbol, String>] the metadata of the node
      attr_writer :id

      def_delegators :@meta, :[], :[]=
      def_delegator :@items, :delete, :delete_item
      def_delegator :@items, :last, :last_item
      protected :delete_item

      def initialize(id: '', title: '', body: '', meta: {})
        raise ArgumentError, "Invalid argument :id" unless id.is_a? String
        raise ArgumentError, "Invalid argument :title" unless title.is_a? String
        raise ArgumentError, "Invalid argument :body" unless body.is_a? String
        raise ArgumentError, "Invalid argument :meta" unless meta.is_a? Hash
        id = meta.delete(:id) if id.empty? && meta[:id]
        meta.delete(:id) unless id.empty?
        @parent = nil
        @items = []
        @id = id
        @title = title
        @body = body
        @meta = meta
      end

      def <<(node)
        raise ArgumentError, "Invalid argument :node" unless node.is_a? Node
        node.parent = self
        @items << node
        node
      end

      # @param id [String] the id of child node; when it starts with '.',
      #   the method will find nodes that id ends with the param
      # @return [Node, nil] child node by provided id; when id not found
      #   it will return ni
      def item(id)
        return @items.find{|r| r.id.end_with? id[1..-1]} if id.start_with? '.'
        @items.find{|r| r.id.eql? id}
      end

      # @return [Array<String>] of ids from meta[:order_index]
      def order_index
        return [] unless @meta[:order_index]
        @meta[:order_index].strip.gsub(/[\s]{2,}/, ' ').split(/\s/)
      end

      # @return [Array<Node>] list of child nodes; when the node
      #   metadate has :order_index arrtibute, the list will be
      #   ordered according the attribute value
      def items
        return @items if @items.empty? || order_index.empty?
        [].tap do |ordered|
          source = Array.new(@items)
          order_index.each do |o|
            e = source.delete(item(o))
            ordered << e if e
          end
          ordered.concat(source)
        end
      end

      # see Enumerable#each
      def each(&block)
        return to_enum(__callee__) unless block_given?
        yield(self)
        items.each{|n| n.each(&block) }
      end

      # @return [Node] the root node in the node hierarchy
      def root
        n = self
        n = n.parent while n.parent
        n
      end

      # @return [Integer] the node level in the node hierarchy
      def nesting_level
        @parent.nil? ? 0 : @parent.nesting_level + 1
      end

      # @return [Array<String>] macro links in the node #body
      def links
        return [] if @body.empty?
        @body.scan(/\[\[([\w\.]*)\]\]/).flatten.uniq
      end

      # When the node id starts with '.', the method will
      #   prefix the node id with parent id
      # @return [String] the id of the node
      def id
        @id.start_with?('.') && @parent ? @parent.id + @id : @id
      end

      # Find the first node in the node hierarchy by its id.
      #   Add '*' prefix to find id by ends_with?
      # @param [String] id Node id
      # @return [Node] or nil when node not found
      def node(id)
        if id.start_with? '*'
          ai = id[1..-1]
          return find {|n| n.id.end_with? ai}
        end
        find{|n| n.id.eql? id}
      end

      # Break of the node from parent hierarhy
      # @return self
      def orphan!
        return unless @parent
        @parent.delete_item(self)
        @parent = nil
        self
      end

      protected
      def parent=(node)
        raise ArgumentError, "Invalid parameter :node" unless node.is_a? Node
        @parent = node
      end

    end
  end
end
