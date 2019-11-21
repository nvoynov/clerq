require_relative "../spec_helper"
include Clerq::Interactors
include Clerq::Entities

describe CheckAssembly do
  class SpecCheck < CheckAssembly
    attr_writer :node
    def nonuniq_ids; super(); end
    def unknown_parents; super(); end
    def unknown_references; super(); end
    def unknown_order_index; super(); end
  end

  let(:interactor) { SpecCheck.new }
  let(:node) { Node.new(id: 'root', meta: {file_name: 'spec.md'}) }

  describe '#nonuniq_ids' do
    it 'must retrun nonuniq ids' do
      node << Node.new(id: node.id, meta: {file_name: 'spec.1.md'})
      interactor.node = node
      _(interactor.nonuniq_ids).must_equal({'root' => ['spec.md', 'spec.1.md']})
    end
  end

  describe '#unknown_parents' do

    it 'must return unknown parents' do
      node << Node.new(id: '10', meta: {parent: '0'})
      node << Node.new(id: '20', meta: {parent: '0'})
      interactor.node = node
      _(interactor.unknown_parents).must_equal({'0' => ['10', '20']})
    end
  end

  # TODO: maybe in future it should include wrong references from :meta
  #   order_index, specified, depend_on, etc.
  describe '#unknown_references' do

    it 'must return unknown references' do
      node << Node.new(id: '.01', body: 'see in [[unknown]]')
      node << Node.new(id: '.02', body: 'see in [[unknown]]')
      interactor.node = node
      _(interactor.unknown_references).must_equal(
         {'unknown' => ['root.01', 'root.02']})
    end
  end

  # TODO: :order_index contains links
  # TODO: unknown_meta_links, unknown_body_links
  describe '#unknown_order_index' do

    it 'must return empty hash' do
      right = Node.new(meta: {order_index: '01 02'})
      right << Node.new(id: '01')
      right << Node.new(id: '02')
      interactor.node = right
      _(interactor.unknown_order_index).must_be_empty
    end

    it 'must return unknown order index' do
      node[:order_index] = 'adm usr'
      interactor.node = node
      _(interactor.unknown_order_index).must_equal(
        {'root' => ['adm', 'usr']})
    end
  end

  # TODO provide Fake NodesRepo?
  # describe '#call' do
  #   it 'must return empty hash when no errors found' do
  #     gateway.save(Node.new(id: 'u'))
  #     result = CheckNodes.()
  #     result.must_be_empty
  #     result.wont_be_nil
  #     result.must_be_kind_of Hash
  #   end
  #
  #   it 'must return many errors ...' do
  #     right = Node.new(id: 'u')
  #     right << Node.new(id: 'us')
  #     right << Node.new(id: 'uc')
  #     gateway.save right
  #     gateway.save Node.new(id: '01', meta: {parent: 'f'})
  #     gateway.save Node.new(id: '02', meta: {order_index: '.01 .02'})
  #     gateway.save Node.new(id: '03', body:
  #       'has right [[u.uc]] and unknown [[f]]')
  #     skip('provide assertions there')
  #   end
  # end

end
