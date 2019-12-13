require_relative '../spec_helper'
include Clerq::Entities
include Clerq::Services

describe ReadNode do

  class SpecReadNode < ReadNode
    attr_reader :node
    public_class_method :new
    def read_nodes(text, &block); super(text, &block); end
    def parse_node(text); super(text); end
    def insert_node(node, level); super(node, level); end
  end

  let(:reader) { SpecReadNode.new('spec.md') }

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
    it 'must not call block for empty text' do
      counter = 0
      reader.read_nodes(StringIO.new.each_line){|n| counter += 1}
      _(counter).must_equal 0
    end

    it 'must call block 6 times for :content' do
      counter = 0
      reader.read_nodes(StringIO.new(content).each_line){|n| counter += 1}
      _(counter).must_equal 6
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
      _(node.id).must_equal ''
      _(node.title).must_equal ''
      _(node.meta).must_equal({source: 'user'})
    end

    it 'must parse :title and :meta' do
      _, node = reader.parse_node("# title\n{{source: user}}")
      _(node.id).must_equal ''
      _(node.title).must_equal 'title'
      _(node.meta).must_equal({source: 'user'})
    end

    it 'must parse :title and :meta and :id in meta' do
      _, node = reader.parse_node("# title\n{{id: 01, source: user}}")
      _(node.id).must_equal '01'
      _(node.title).must_equal 'title'
      _(node.meta).must_equal({source: 'user'})
    end

    it 'must parse :title and :meta and :id in meta 1' do
      text = "# Main\n{{id: 00, parent: 00}}"
      _, node = reader.parse_node(text)
      _(node.id).must_equal '00'
      _(node.title).must_equal 'Main'
      _(node.meta).must_equal({parent: '00'})
      _(node.body).must_equal ''
    end

    it 'must parse :meta delimiters' do
      txt = "#\n{{p1: 1; p2: 2, p3: 3\np4: 4\n}}"
      hsh = {p1: '1', p2: '2', p3: '3', p4: '4'}
      _, node = reader.parse_node(txt)
      _(node.meta).must_equal hsh
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

  describe '#call' do
    it 'must return array of nodes' do
      Sandbox.() do
        File.write('node.md', content)
        ary = ReadNode.('node.md')
        _(ary).must_be_kind_of Array
        _(ary.size).must_equal 5
      end
    end

    it 'must read ...' do
      text = <<~EOF
        # Main
        {{id: 00}}

        # Part 1
        {{id: 01, parent: 00}}

        # [02] Part 2
        {{parent: 00}}
      EOF

      Sandbox.() do
        File.write('text.md', text)
        ary = ReadNode.('text.md')

        _(ary.size).must_equal 3
        _(ary[0].id).must_equal '00'
        _(ary[0].title).must_equal 'Main'

        _(ary[1].id).must_equal '01'
        _(ary[1].title).must_equal 'Part 1'

        _(ary[2].id).must_equal '02'
        _(ary[2].title).must_equal 'Part 2'
      end
    end


  end

end
