require_relative '../spec_helper'

describe 'clerq check' do

  describe 'when no errors found' do
    it 'must repsond no errors found' do
      ClerqSandbox.() do
        Clerq.reset
        cmd = ->{ Clerq::Cli.start ['check']}
        _(proc{ cmd.call }).must_output "No errors found\n"
      end
    end
  end

  describe 'when errors found' do
    it 'must print errors'
  end

end
