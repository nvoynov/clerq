# encoding: UTF-8
require_relative 'service'
require_relative '../entities/node'
include Clerq::Entities

module Clerq
  module Services

    # The service reads nodes from file and returns array of nodes
    # It returns array because the file can have a few root nodes
    class ReadNode < Service

      def call
        # FIXME: something wrong here when foreach!
        #
        text = File.read(@filename)
        read_nodes(text) do |node_text|
          level, node = parse_node(node_text)
          next unless node
          node[:filename] = @filename
          insert_node(node, level)
        end

        ary = Array.new(@node.items)
        ary.each(&:orphan!)
        ary
      end

      # @param filename [String] input file for reading
      # @param on_error [Proc] proc object {|error| ...}
      def initialize(filename, on_error = nil)
        @filename = filename
        @on_error = on_error
        @node = Node.new(id: filename)
      end

      protected

      # @param [Enumerator<String>] text
      # @return [Array<String>] where each item represents one node
      def read_nodes(text, &block)
        quote, node = false, []
        text = text.split(?\n) unless text.is_a? Enumerator
        text.each do |line|
          if line.start_with?('#') && !quote && !node.empty?
            block.call(node.join("\n"))
            node = []
          end
          node << line
          quote = !quote if line.start_with?('```')
        end
        block.call(node.join("\n")) unless node.empty?
      end

      def insert_node(node, level)
        parent = @node
        while parent.last_item && (parent.nesting_level + 1) < level
          parent = parent.last_item
        end
        unless (parent.nesting_level + 1) == level
          msg = "invalid header level: #{'#' * level} #{node.title}"
          @on_error.call(msg) if @on_error
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
        msg = "invalid node format: #{text}"
        @on_error.call(msg) if @on_error
        [nil, nil]
      end

      def parse_meta(text)
        text.strip.split(/[;,\n]/).inject({}) do |h, i|
          pair = /\s?(\w*):\s*(.*)/.match(i)
          h.merge(pair[1].to_sym => pair[2])
        end || {}
      rescue StandardError
        msg = "invalid meta format:\n{{#{text}}}"
        @on_error.call(msg) if @on_error
        {}
      end

      NODE_REGX =
        /^(\#+)[ ]*(\[([^\[\]\s]*)\][ ]*)?([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m

    end

  end
end
