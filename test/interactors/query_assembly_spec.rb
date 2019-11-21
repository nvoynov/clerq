require_relative '../spec_helper'
include Clerq::Interactors
include Clerq::Repositories
include Clerq::Entities

describe QueryAssembly do

  class SpecRepo < NodeRepository
    def assemble
      node = Node.new(id: 'join', title: Clerq.title)
      node << Node.new(id: '001', title: '001')
      node << Node.new(id: '002', title: '002')
      node.node('001') << Node.new(id: '011', title: '011')
      node.node('001') << Node.new(id: '012', title: '012')
      node
    end
  end

  let(:repo) { SpecRepo.new }

  before do
    Clerq.node_repository = repo
  end

  describe 'when query not provided' do
    it 'must return assembly' do
      asmb = QueryAssembly.()
      _(asmb.title).must_equal Clerq.title
    end
  end

  describe 'when query provided' do

    describe 'when parameter is wrong' do
      it 'must raise ArgumentError' do
        _(proc{QueryAssembly.(1)}).must_raise ArgumentError
      end
    end

    describe 'when query_string is wrong' do
      it 'must raise ::Failure' do
        _(proc{QueryAssembly.("err")}).must_raise QueryAssembly::Failure
      end
    end

    describe 'when no nodes found' do
      it 'must return root node with meta[:query]' do
        node = QueryAssembly.("1 != 1")
        _(node.items.size).must_equal 0
        _(node.title).must_equal Clerq.title
        _(node[:query]).must_equal "1 != 1"
      end
    end

    describe 'when few nodes found' do
      it 'must return root node with meta[:query]' do
        node = QueryAssembly.("['011', '012'].include?(node.id)")
        _(node.title).must_equal Clerq.title
        _(node.items.size).must_equal 2
        _(node[:query]).wont_be_nil
      end
    end

    describe 'when one single node found' do
      it 'must return this node as root' do
        node = QueryAssembly.("node.id == '001'")
        _(node.title).must_equal '001'
        _(node.items.size).must_equal 2
      end
    end

  end
end
