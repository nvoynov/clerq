# encoding: UTF-8

require 'erb'
require_relative 'service'

module Clerq
  module Services

    # Render @object trough ERB temlate
    #
    # Usage
    #   erb = "id: <%= @object.id %>\ntitle: <%= @object.title %>\n"
    #   obj = Node.new(id: 'uc', title: 'Use Cases', meta: {skip_meta: true})
    #   txt = RenderErb.call(erb, obj) # or RenderErb.(erb, obj)
    class RenderErb < Service

      def call
        tt = ERB.new(@erb, nil, "-")
        tt.result(binding)
      end

      def initialize(erb: , object: )
        @erb = erb
        @object = object
      end
    end

  end
end
