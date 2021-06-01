require 'clerq'
require 'minitest/autorun'
require_relative "../markup_macro"
require_relative "../markup_node"
include Clerq::Entities

describe MarkupMacro do

  let(:node) {
    node = Node.new(title: "SRS")
    node << Node.new(id: "ii", title: "Introduction")
    node << Node.new(id: "ur", title: "User Requirements")
    node << Node.new(id: "fr", title: "Functional Requirements")
    node.item("ur") << Node.new(id: ".us", title: "User Stories")
    node.item("ur") << Node.new(id: ".uc", title: "Use Cases")
    MarkupNode.new(node)
  }

  describe "SkipMacro#process" do
    let(:macro) { SkipMacro.new }
    let(:input) { "{{@skip some text}}" }
    let(:result) { "" }

    it 'must return result' do
      _(macro.process(input, node)).must_equal result
    end
  end

  describe "EvalMacro#process" do
    let(:macro) { EvalMacro.new }
    let(:input) {
      <<~EOF
          {{@@eval
            ary = []
            3.times{|i| ary << "Hello, World!"}
            ary.join("\n")
          }}
        EOF
    }
    let(:result) {
      <<~EOF.chomp
          Hello, World!
          Hello, World!
          Hello, World!
        EOF
    }

    it 'must return result' do
      _(macro.process(input, node)).must_equal result
    end

    it 'must pass node binding' do
      _(macro.process("{{@@eval \"#{node.id} #{node.title}\"}}", node)).must_equal " SRS"
    end
  end

  describe "ListMacro#process" do
    let(:macro) { ListMacro.new }
    let(:input) { "{{@@list}}"  }
    let(:result) {
      <<~EOF.chomp
        * [Introduction](#ii)
        * [User Requirements](#ur)
        * [Functional Requirements](#fr)
      EOF
    }

    it 'must return result' do
      _(macro.process(input, node)).must_equal result
    end
  end

  describe "TreeMacro#process" do
    let(:macro) { TreeMacro.new }
    let(:input) { "{{@@tree}}"  }
    let(:result) {
      <<~EOF.chomp
        * [Introduction](#ii)
        * [User Requirements](#ur)
           * [User Stories](#ur-us)
           * [Use Cases](#ur-uc)
        * [Functional Requirements](#fr)
      EOF
    }

    it 'must return result' do
      _(macro.process(input, node)).must_equal result
    end
  end

end
