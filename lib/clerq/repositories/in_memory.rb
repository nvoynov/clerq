require_relative 'repository'

module Clerq
  module Repositories

    class InMemory < Repository

      def initialize
        @counter = 0
        @items = {}
      end

      def items(id = nil)
        return @items[id] if id
        @items.values
      end

      def find(id)
        @items[id]
      end

      def save(e)
        raise ArgumentError, "Invalid argument" unless entity?(e)
        id = has_id?(e) ? e.id : counter
        @items[id] = e
      end

      protected

        def counter
          @counter += 1
        end

        def has_id?(e)
          e.id && !e.id.empty?
        end

        def entity?(e)
          e.is_a?(Object) && e.respond_to?(:id)
        end

    end

  end
end
