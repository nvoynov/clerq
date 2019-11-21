# encoding: UTF-8

require 'erb'

module Clerq

  # Render @object trough ERB temlate
  #
  # Usage
  #   erb = "id: <%= @object.id %>\ntitle: <%= @object.title %>\n"
  #   obj = Node.new(id: 'uc', title: 'Use Cases', meta: {skip_meta: true})
  #   txt = RenderErb.call(erb, obj) # or RenderErb.(erb, obj)
  class RenderErb

    # @param erb [Text] ERB template
    # @param object [Object]
    # @result [String?]
    def self.call(erb: , object: )
      new(erb: erb, object: object).call
    end

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
