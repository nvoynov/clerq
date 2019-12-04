require_relative '../spec_helper'
include Clerq::Repositories
include Clerq::Services
include Clerq::Entities

describe QueryNode do

   let(:assembly) {
     Node.new(id: 'join', title: Clerq.title).tap do |node|
       node << Node.new(id: '001', title: '001')
       node << Node.new(id: '002', title: '002')
       node.node('001') << Node.new(id: '011', title: '011')
       node.node('001') << Node.new(id: '012', title: '012')
     end
   }

  describe 'when query provided' do

    describe 'when parameter is wrong' do
      it 'must raise ArgumentError' do
        _(proc{QueryNode.(assembly: assembly, query: 1)}).must_raise ArgumentError
      end
    end

    describe 'when query_string is wrong' do
      it 'must raise ::Failure' do
        _(proc{QueryNode.(query: "err")}).must_raise ArgumentError
      end
    end

    describe 'when no nodes found' do
      it 'must return root node with meta[:query]' do
        node = QueryNode.(assembly: assembly, query: "1 != 1")
        _(node.items.size).must_equal 0
        _(node.title).must_equal Clerq.title
        _(node[:query]).must_equal "1 != 1"
      end
    end

    describe 'when few nodes found' do
      it 'must return root node with meta[:query]' do
        node = QueryNode.(assembly: assembly, query: "['011', '012'].include?(node.id)")
        _(node.title).must_equal Clerq.title
        _(node.items.size).must_equal 2
        _(node[:query]).wont_be_nil
      end
    end

    describe 'when one single node found' do
      it 'must return this node as root' do
        node = QueryNode.(assembly: assembly, query: "node.id == '001'")
        _(node.title).must_equal '001'
        _(node.items.size).must_equal 2
      end
    end

  end
end
