module Clerq
  module Gateways

    class Gateway
      # @return [Array<Node>]
      def nodes; end

      # @return [Array<Template>]
      def templates; end

      # @param obj [Node or Template]
      def save(obj); end

    end

  end
end
