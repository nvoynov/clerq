# encoding: UTF-8

require_relative '../spec_helper'
include Clerq::Services
include Clerq::Entities

describe RenderNode do

  class FakeTextRepo < TextRepository
    def text(name)
      return '<%= @object.title %>' if name == 'spec'
      raise StandardError, "'#{name}' template not found"
    end
  end

  let(:node) {Node.new(id: '0', title: Clerq.title)}

  let(:text_repo) {FakeTextRepo.new}

  before do
    Clerq.text_repository = text_repo
  end

  describe 'failures' do

    it 'must raise ArgumentError for invalid paramters' do
      prc = Proc.new { RenderNode.(node: node,template: 1) }
      _(->{ prc.call }).must_raise ArgumentError

      prc = Proc.new { RenderNode.(node: node,query: 1) }
      _(->{ prc.call }).must_raise ArgumentError
    end

    it 'must raise Failure when template not found' do
      prc = Proc.new { RenderNode.(node: node, template: 'wrong') }
      err = _(->{ prc.call }).must_raise StandardError
      _(err.message).must_match "template not found"
    end

  end

  describe 'success' do
    it 'must return rendered text by template' do
      RenderNode.(node: node,template: 'spec')
      text = RenderNode.(node: node,template: 'spec')
      _(text).must_match Clerq.title
    end
  end

end
