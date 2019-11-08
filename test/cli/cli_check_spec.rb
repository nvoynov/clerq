require_relative '../spec_helper'

describe '#check' do
  let(:source) { File.join(Clerq.settings.src, 'contents.md') }

  it 'must not raise exception at least' do
    Sandbox.project do
      Clerq::Cli.start ['check']
    end
  end

end
