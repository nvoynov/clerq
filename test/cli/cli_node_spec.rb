require_relative '../spec_helper'

describe 'clerq node' do

  describe 'when exec outside Clerq' do
    it 'must stop' do
      _(proc { Clerq::Cli.start ['build'] }).must_output(
        "", /Clerq project required!/
      )
    end
  end

  describe 'when exec with ID' do
  end

  describe 'when exec with ID TITLE' do
  end

  describe 'when exec with ID -t' do
  end

end
