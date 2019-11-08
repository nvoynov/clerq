require_relative "../spec_helper"
include Clerq::Interactors
include Clerq::Entities

describe CreateNode do

  before do
    Clerq.gateway = Clerq::Gateways::InMemory.new
  end

  let(:gateway) { Clerq.gateway }

  describe 'Success' do
    def each_combination(params, &block)
      1.upto(params.size) do |n|
        params.keys.combination(n).each.with_index do |c, index|
          param = c.inject({}){|h, p| h.merge!({p => params[p]})}
          block.call(n * 10 + index, param)
        end
      end
    end

    it 'must create node' do
      parameters = {title: 'title', body: 'body', meta: {source: 'user'}}
      each_combination(parameters) do |index, params|
        CreateNode.(**params.merge({id: index.to_s}))
        node = gateway.nodes(index.to_s)
        node.wont_be_nil
        params.keys.each{|p| node.send(p).must_equal params[p] }
      end
    end

    it 'must create node by template' do
      gateway.save(Template.new(id: 'tt', body: 'template'))
      CreateNode.(id: 'id', template: 'tt')
      node = gateway.nodes('id')
      node.wont_be_nil
      node.body.must_equal 'template'
    end
  end

  describe 'Failure' do
    it 'must fail when template not found' do
      err = ->{ CreateNode.(id: 'id', template: 'wrong') }.must_raise CreateNode::Failure
      err.message.must_match(/Template not found/)
    end
  end

end
