require_relative "../spec_helper"
include Clerq::Interactors
include Clerq::Entities

class SpecQuery < QueryNodes
  attr_accessor :query
  def make_response(arg); super(arg); end
  def prepare_query; super(); end
end

describe QueryNodes do

  before do
    Clerq.gateway = Clerq::Gateways::InMemory.new
  end

  let(:interactor) { SpecQuery.new(query: '1 == 1') }
  let(:gateway) { Clerq.gateway }

  describe '#make_response(result) must always return Node' do
    it 'must return new Node for emtpy array' do
      node = interactor.make_response([])
      node.wont_be_nil
      node.must_be_kind_of Node
      node.items.must_be_empty
    end

    it 'must return the node for [node]' do
      demo = Node.new(id: 'u')
      node = interactor.make_response([demo])
      node.must_equal demo
    end

    it 'must return Node' do
      n1 = Node.new(id: 'u')
      n2 = Node.new(id: 'f')
      node = interactor.make_response([n1, n2])
      node.items.size.must_equal 2
      node.to_a.must_equal [node, n1, n2]
    end
  end

  describe '#prepare_query' do
    it 'must accept valid query' do
      interactor.query = '1 == 1'
      interactor.prepare_query.wont_be_nil
      interactor.query = "node.id == 'u'"
      interactor.prepare_query.wont_be_nil
    end

    it 'must fail! for invalid query' do
      interactor.query = 'n'
      proc { interactor.prepare_query }.must_raise SpecQuery::Failure
    end
  end

  describe '#call' do
    it 'must return query result' do
      gateway.save(Node.new(id: 'u'))
      gateway.save(Node.new(id: '.us', meta: {parent: 'u'}))
      gateway.save(Node.new(id: '.uc', meta: {parent: 'u'}))
      gateway.save(Node.new(meta: {parent: 'u.uc'}))
      gateway.save(Node.new(meta: {parent: 'u.uc'}))

      node = QueryNodes.(query: "node.id == 'u'")
      node.wont_be_nil
      node.must_be_kind_of Node
      node.id.must_equal 'u'
    end

    it 'must return orphaned nodes'
  end

  describe 'when query result is empty' do
    it 'must return what?'
  end

end
