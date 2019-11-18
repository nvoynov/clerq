require_relative '../spec_helper'

describe '#check' do
  let(:source) { File.join(Clerq.settings.src, 'contents.md') }

  describe 'when exec outside Clerq' do
    it 'must stop' do
      _(proc { Clerq::Cli.start ['check'] }).must_output(
        "", /Clerq project required!/
      )
    end
  end

  it 'must not raise exception at least' do
    Sandbox.project do
      Clerq::Cli.start ['check']
    end
  end

end
