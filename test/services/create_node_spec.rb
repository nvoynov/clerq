require_relative "../spec_helper"
include Clerq::Repositories
include Clerq::Services
include Clerq::Entities

describe CreateNode do

  class SpecTextRepo < TextRepository
    def text(name)
      return 'Spec' if name == 'spec'
      raise StandardError, "'#{name}' template not found"
    end
  end

  class SpecNodeRepo < NodeRepository
    attr_reader :storage
    def save(node)
      @storage ||= {}
      raise StandardError, "'#{node.id}' already exists" if @storage[node.id]
      @storage[node.id] = node
    end
  end

  let(:text_repo) {SpecTextRepo.new}
  let(:node_repo) {SpecNodeRepo.new}

  before do
    Clerq.text_repository = text_repo
    Clerq.node_repository = node_repo
  end

  describe 'failures' do
    it 'must fail when template not found' do
      prc = Proc.new { CreateNode.(id: '1', template: 'wrong') }
      err = _(->{ prc.call }).must_raise StandardError
      _(err.message).must_match "template not found"
    end

    it 'must fail when node.id already in repository' do
      prc = Proc.new { CreateNode.(id: '1') }
      prc.call
      err = _(->{ prc.call }).must_raise StandardError
      _(err.message).must_match "already exists"
    end
  end

  describe 'success' do

    def each_combination(params, &block)
      1.upto(params.size) do |n|
        params.keys.combination(n).each.with_index do |c, index|
          param = c.inject({}){|h, p| h.merge!({p => params[p]})}
          block.call(n * 10 + index, param)
        end
      end
    end

    let(:params) {
      { title: 'title', body: 'body', meta: {source: 'user'} }
    }

    it 'must create node' do
      each_combination(params) do |index, p|
        CreateNode.(**p.merge({id: index.to_s}))
        node = node_repo.storage[index.to_s]
        p.keys.each{|p| _(node.send(p)).must_equal params[p] }
      end
    end

    it 'must create node by template' do
      CreateNode.(id: 'id', template: 'spec')
      node = node_repo.storage['id']
      _(node.body).must_equal 'Spec'
    end
  end

end
