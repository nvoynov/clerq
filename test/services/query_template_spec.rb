require_relative '../spec_helper'
include Clerq::Services
include Clerq::Repositories

describe QueryTemplate do

  class TextSpecRepo < TextRepository
    def text(name)
      data = {}
      data['spec.md.erb'] = 'spec'
      data['spec.md.tt'] = 'spec'
      data['spec'] = 'spec'
      body = data[name]
      return body if body
      raise StandardError, "File '#{name}' not found"
    end
  end

  let(:repo) { TextSpecRepo.new }

  before do
    Clerq.text_repository = repo
  end

  it 'must return template body' do
    _(QueryTemplate.('spec')).must_equal 'spec'
    _(QueryTemplate.('spec.md.tt')).must_equal 'spec'
    _(QueryTemplate.('spec.md.erb')).must_equal 'spec'
  end

  it 'must raise ::Failure when template not found' do
    _(proc{QueryTemplate.('tt.does.not.exist')}).must_raise StandardError
  end

end
