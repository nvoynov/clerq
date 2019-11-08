# encoding: UTF-8

require 'erb'

module Clerq

  # Compile @object to text in accordance with @template
  # Usage
  #   tt = "id: <%= @object.id %>\ntitle: <%= @object.title %>\n"
  #   n = Node.new(id: 'uc', title: 'Use Cases', meta: {skip_meta: true})
  #   text = Templater.call(tt, n) # or Templater.(tt, n)
  class Templater

    # @param tt [Template]
    # @param object [Object]
    # @result [String?]
    def self.call(template, object)
      new(template, object).call
    end

    def call
      tt = ERB.new(@template, nil, "-")
      tt.result(binding)
    end

    def initialize(template, object)
      @template = template
      @object = object
    end
  end

end
