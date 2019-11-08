require_relative "../spec_helper"
include Clerq::Interactors
include Clerq::Entities

class SpecJoinNodes < JoinNodes
  attr_accessor :node
  def join(nodes); super(nodes); end
  def subordinate!; super(); end
  def equip_ident!; super(); end
end

describe JoinNodes do
  before do
    Clerq.gateway = Clerq::Gateways::InMemory.new
  end

  let(:interactor) { SpecJoinNodes.new }
  let(:gateway) { Clerq.gateway }

  describe '#join(nodes) must always return Node' do
    it 'must return new Node for emtpy array' do
      node = interactor.join([])
      node.wont_be_nil
      node.must_be_kind_of Node
      node.to_a.must_equal [node]
    end

    it 'must return the node for [node]' do
      demo = Node.new(id: 'u')
      node = interactor.join([demo])
      node.must_equal demo
    end

    it 'must return Node' do
      n1 = Node.new(id: 'u')
      n2 = Node.new(id: 'f')
      node = interactor.join([n1, n2])
      node.items.size.must_equal 2
      node.to_a.must_equal [node, n1, n2]
    end
  end

  describe '#subordinate!' do
    it 'must place nodes according meta[:parent]' do
      root = Node.new
      root << Node.new(id: 'u')
      root << Node.new(id: 'f')
      root << Node.new(id: '.us', meta: {parent: 'u'})
      root << Node.new(id: '.us1', meta: {parent: 'u.us'})
      interactor.node = root
      interactor.subordinate!

      root.items.size.must_equal 2
      root.node('u.us').parent.must_equal root.node('u')
      root.node('u.us.us1').parent.must_equal root.node('u.us')
    end
  end

  describe '#equip_ident!' do
    it 'must equip nodes with auto-generated ids when id is empty' do
      root = Node.new
      root << Node.new
      u = root << Node.new(id: 'u')
      u << Node.new
      u << Node.new
      interactor.node = root
      interactor.equip_ident!
      root.items.first.id.must_equal '01'
      u.items.first.id.must_equal 'u.01'
      u.items.last.id.must_equal 'u.02'
    end
  end

  describe '#call' do
    it 'must get node repository, join, subordinate, and equip_ident' do
      gateway.nodes.must_equal []
      gateway.save(Node.new(id: 'u'))
      gateway.save(Node.new(id: '.us', meta: {parent: 'u'}))
      gateway.save(Node.new(id: '.uc', meta: {parent: 'u'}))
      gateway.save(Node.new(meta: {parent: 'u.uc'}))
      gateway.save(Node.new(meta: {parent: 'u.uc'}))
      gateway.save(Node.new())
      node = JoinNodes.()
      node.id.must_equal 'join'
      node.items.size.must_equal 2 # u, f
      node.items.last.id.must_equal '01'
      node.items.first.items.size.must_equal 2 # .uc, .uc
      uc = node.node('u.uc')
      uc.items.first.id.must_equal 'u.uc.01'
      uc.items.last.id.must_equal 'u.uc.02'
    end

    it 'must return top node and one inside (join -> srs)' do
      gateway.save(Node.new(id: 'srs', title: 'SRS'))
      gateway.save(Node.new(title: 'User requirements', meta: {parent: 'srs'}))
      gateway.save(Node.new(title: 'Func requirements', meta: {parent: 'srs'}))

      node = JoinNodes.()
      node.id.must_equal 'join'
      node.items.size.must_equal 1
    end
  end

end
