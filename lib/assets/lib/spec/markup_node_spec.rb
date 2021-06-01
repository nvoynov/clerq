require 'clerq'
require 'minitest/autorun'
require_relative "../markup_node"
include Clerq::Entities

describe MarkupNode do
  let(:node) {
    root = Node.new
    node = Node.new(id: 'id', title: 'Title', body: 'Body')
    root << node
    MarkupNode.new(node)
  }

  describe '#markup' do
    let(:output) {
      <<~EOF.strip
        # Title {#id}

        Attribute | Value
        --------- | -----
        id | id

        Body
      EOF
    }

    it 'must return markup' do
      _(node.markup).must_equal output
    end

    it 'must replace links'
    it 'must process macro'
  end
end
