require_relative '../spec_helper'
include Clerq::Interactors
include Clerq::Entities

describe RenderAssembly do

  class FakeTextRepo < TextRepository
    def text(name)
      return '<%= @object.title %>' if name == 'spec'
      raise StandardError, "'#{name}' template not found"
    end
  end

  # This stuff very usefull especiall because repo#asseble always return root!
  # something like NullObject idiom
  class FakeNodeRepo < NodeRepository
    attr_reader :storage
    def load
      []
    end
  end

  let(:text_repo) {FakeTextRepo.new}
  let(:node_repo) {FakeNodeRepo.new}

  before do
    Clerq.text_repository = text_repo
    Clerq.node_repository = node_repo
  end

  describe 'failures' do

    it 'must raise ArgumentError for invalid paramters' do
      prc = Proc.new { RenderAssembly.(template: 1) }
      _(->{ prc.call }).must_raise ArgumentError

      prc = Proc.new { RenderAssembly.(query: 1) }
      _(->{ prc.call }).must_raise ArgumentError
    end

    it 'must raise Failure when template not found' do
      prc = Proc.new { RenderAssembly.(template: 'wrong') }
      err = _(->{ prc.call }).must_raise RenderAssembly::Failure
      _(err.message).must_match "template not found"
    end

    it 'must raise Failure when query invalid' do
      prc = Proc.new { RenderAssembly.(template: 'spec', query: 'wrong') }
      err = _(->{ prc.call }).must_raise RenderAssembly::Failure
      _(err.message).must_match "eval() as"
    end
  end

  describe 'success' do
    it 'must return rendered text by template' do
      text = RenderAssembly.(template: 'spec')
      _(text).must_match Clerq.title
    end
  end

end
