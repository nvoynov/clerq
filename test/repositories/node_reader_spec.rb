require_relative '../spec_helper'
include Clerq::Repositories

describe NodeReader do
  class SpecReader < NodeReader
    attr_reader :node, :errors
    def initialize(file); super(file); end
    def read_nodes(text); super(text); end
    def parse_node(text); super(text); end
    def insert_node(node, level); super(node, level); end
  end

  let(:reader) { SpecReader.new('spec.md') }

  let(:content) {
    <<~EOF
      # [id.1] Title 1
      {{source: user}}

      Body 1

      # [id.2] Title 2
      # [id.3]
      # Title 4
      #
      ##
    EOF
  }

  describe '#read_nodes' do
    it 'must return array for empty text' do
      nodes = reader.read_nodes(StringIO.new.each_line)
      _(nodes).must_equal []
    end

    it 'must return array' do
      nodes = reader.read_nodes(StringIO.new(content).each_line)
      _(nodes.size).must_equal 6
    end
  end

  describe '#parse_node' do
    it 'must parse 1' do
      level, node = reader.parse_node('#')
      _(level).must_equal 1
      _(node.id).must_equal ''
      _(node.title).must_equal ''
      _(node.body).must_equal ''
      _(node.meta).must_equal({})
    end

    it 'must parse 2' do
      level, node = reader.parse_node('##')
      _(level).must_equal 2
      _(node).wont_be_nil
    end

    it 'must parse :id' do
      _, node = reader.parse_node('# [id]')
      _(node.id).must_equal 'id'
    end

    it 'must parse :id and :title' do
      _, node = reader.parse_node('# [id] Title')
      _(node.id).must_equal 'id'
      _(node.title).must_equal 'Title'
    end

    it 'must parse :title' do
      _, node = reader.parse_node('# Title')
      _(node.id).must_equal ''
      _(node.title).must_equal 'Title'
    end

    it 'must parse :meta' do
      _, node = reader.parse_node("#\n{{source: user}}")
      _(node.title).must_equal ''
      _(node.meta).must_equal({source: 'user'})
    end

    it 'must parse full form' do
      text = <<~EOF
        # [id] Title
        {{source: user}}
        Body
      EOF
      _, node = reader.parse_node(text)
      _(node.id).must_equal 'id'
      _(node.title).must_equal 'Title'
      _(node.body).must_equal 'Body'
      _(node.meta).must_equal({source: 'user'})
    end
  end

  describe '#insert_node' do
    it 'must add item for 1st level header' do
      reader.insert_node(Node.new(id: '1'), 1)
      _(reader.node.items.size).must_equal 1
      reader.insert_node(Node.new(id: '2'), 1)
      _(reader.node.items.size).must_equal 2
    end

    it 'must add to last in hierarchy' do
      reader.insert_node(Node.new(id: '1'), 1) # node.items.first
      reader.insert_node(Node.new(id: '1.1'), 2)
      reader.insert_node(Node.new(id: '1.1.1'), 3)
      reader.insert_node(Node.new(id: '1.1.2'), 3)
      reader.insert_node(Node.new(id: '1.2'), 2)
      _(reader.node.items.size).must_equal 1
      _(reader.node.node('1').items.size).must_equal 2
      _(reader.node.node('1.1').items.size).must_equal 2
    end

    it 'must add to item when node level incorrect' do
      reader.insert_node(Node.new(id: '1'), 1)
      reader.insert_node(Node.new(id: '1.1'), 2)
      reader.insert_node(Node.new(id: '1.1.1'), 4)
      _(reader.node.items.size).must_equal 2
    end
  end

  describe 'self#call' do
    it 'must return array of nodes' do
      Sandbox.() do
        File.write('node.md', content)
        nodes = NodeReader.('node.md')
        _(nodes).must_be_kind_of Array
        _(nodes.size).must_equal 5
      end
    end
  end

  describe 'console output' do
    it 'must print reading file and reading result'
    it 'must print reading errors to STDERR'
  end

end
