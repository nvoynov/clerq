require_relative '../spec_helper'
include Clerq

describe RenderErb do

  class SpecObject
    attr_reader :title
    def initialize(title)
      @title = title
    end
  end

  let(:obj) { SpecObject.new "Specq" }
  let(:erb) { "<%= @object.title %>" }

  it 'must render object by template' do
    text = RenderErb.(erb: erb, object: obj)
    _(text).must_match "Specq"
  end

end
