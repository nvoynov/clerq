# encoding: UTF-8

require_relative '../entities'
include Clerq::Entities

module Clerq
  module Repositories
  end
end

class Clerq::Repositories::NodeReader

  # @param [String] file_name with node
  # @return [Array<Node>] from file
  def self.call(file_name)
    new(file_name).call
  end

  # @param [Enumerator] lines; for testing purpose
  # @return [Array<Node>] from file
  def call(text = File.foreach(@file_name))
    STDOUT.print "Reading #{@file_name} ..."

    read_nodes(text).each do |node_text|
      level, node = parse_node(node_text)
      next unless node
      node[:file_name] = @file_name
      insert_node(node, level)
    end

    STDOUT.puts @errors.empty? ? "OK" : "Errors found"
    unless @errors.empty?
      STDERR.puts "Errors reading #{@file_name}"
      STDERR.puts @errors.map{|e| "\t#{e}"}.join("\n")
    end

    nodes = Array.new(@node.items)
    nodes.each(&:orphan!)
    nodes
  end

  protected

    def initialize(file_name)
      @file_name = file_name
      @node = Node.new(id: file_name)
      @errors = []
    end

    # @param [Enumerator<String>] text
    # @return [Array<String>] where each item represents one node
    def read_nodes(text)
      [].tap do |nodes|
        quote, body = false, ''
        text.each do |line|
          if line.start_with?('#') && !quote && !body.empty?
            nodes << body
            body = ''
          end
          body << line
          quote = !quote if line.start_with?('```')
        end
        nodes << body unless body.empty?
      end
    end

    def insert_node(node, level)
      parent = @node
      while parent.last_item && (parent.nesting_level + 1) < level
        parent = parent.last_item
      end
      unless (parent.nesting_level + 1) == level
        @errors << "invalid header level: #{'#' * level} [#{node.id}]"
        parent = @node
      end
      parent << node
    end

    def parse_node(text)
      text += "\n" unless text.end_with?("\n")
      parts = NODE_REGX.match(text)
      lv = parts[1] || ''
      id = parts[3] || ''
      title = parts[4] || ''
      body = parts[7] || ''
      meta = {}
      meta.merge!(parse_meta(parts[6])) if parts[6]
      [lv.size, Node.new(id: id, title: title, body: body.strip, meta: meta)]
    rescue StandardError
      @errors << "invalid node format:\n#{text}"
      [nil, nil]
    end

    def parse_meta(text)
      text.strip.split(/[;,\n]/).inject({}) do |h, i|
        pair = /\s?(\w*):\s*(.*)/.match(i)
        h.merge(pair[1].to_sym => pair[2])
      end || {}
    rescue StandardError
      @errors << "invalid meta format:\n{{#{text}}}"
      {}
    end

    NODE_REGX =
      /^(\#+)[ ]*(\[([^\[\]\s]*)\][ ]*)?([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m

end
