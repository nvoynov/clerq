# encoding: UTF-8

require_relative '../entities'
require_relative 'repository'
include Clerq::Entities

module Clerq
  module Repositories

    class TemplateRepository < Repository
      attr_reader :path
      def initialize(path = Dir.pwd)
        @items = {}
        @path = path
      end

      # TODO move id parameter to #find
      def items(id = nil)
        load if @items.empty?
        return find(id) if id
        @items.values
      end

      def find(id)
        return @items[id] if @items[id]
        PATTERNS.each do |p|
          i0 = "#{id}#{p[1..-1]}"
          return @items[i0] if @items[i0]
        end
        return nil
      end

      def save(tt)
        raise ArgumentError, "Invalid argument" unless tt.is_a? Template
        Dir.chdir(@path){ File.write(tt.id, tt.body) }
      end

      protected

      def load
        Dir.chdir(@path) do
          Dir.glob(PATTERNS)
            .map {|f| Template.new(id: f, body: File.read(f))}
            .each{|t| @items[t.id] = t}
        end
      end

      PATTERNS = ['*.tt', '*.erb']

    end

  end
end
