# encoding: UTF-8
require "forwardable"

module Clerq
  module Entities
  end
end

class Clerq::Entities::Node
  extend Forwardable
  include Enumerable

  attr_reader :parent
  attr_reader :title
  attr_reader :body
  attr_reader :meta
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

  # Find child node in @items for :order_index
  # @param [String] node id
  # @return [Node] when id found or nil if did not
  def item(id)
    return @items.find{|r| r.id.end_with? id[1..-1]} if id.start_with? '.'
    @items.find{|r| r.id.eql? id}
  end

  # @return [Array<Node>] array of items ordered by order_index meta
  def items
    return @items if @items.empty?
    return @items if @meta[:order_index].nil?
    source = Array.new(@items)
    order = @meta[:order_index]
    [].tap do |ordered|
      order.split(/ /).each do |o|
        e = source.delete(item(o))
        ordered << e if e
      end
      ordered.concat(source)
    end
  end

  # TODO: place valid Yard pointer to Enumerable#each
  def each(&block)
    return to_enum(__callee__) unless block_given?
    yield(self)
    items.each{|n| n.each(&block) }
  end

  # TODO: it needs for writing, maybe shold be moved to decorator?
  def root
    n = self
    n = n.parent while n.parent
    n
  end

  # TODO: it needs for writing, maybe shold be moved to decorator?
  def nesting_level
    @parent.nil? ? 0 : @parent.nesting_level + 1
  end

  # TODO: it needs for checking links and writing, maybe
  #   shold be moved to decorator for checking also?
  # @return [Array<String>] links to other nodes inside @body
  def links
    return [] if @body.empty?
    @body.scan(/\[\[([\w\.]*)\]\]/).flatten.uniq
  end

  def id
    @id.start_with?('.') && @parent ? @parent.id + @id : @id
  end

  # Find the first node in the node hierarchy by its id. It allows
  #   finding a node by matching the end of id by providing '*' prefix,
  # @param [String] id Node id
  # @return [Node] or nil when node not found
  def node(id)
    return find{|n| n.id.end_with? id[1..-1]} if id.start_with? '*'
    find{|n| n.id.eql? id}
  end

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
