require_relative '../spec_helper'
include Clerq

describe Cli do

  describe '#version' do
    let(:commands) {['-v', '--version']}

    it 'must return current version' do
      commands.each do |cmd|
        _(proc {Cli.start [cmd]}).must_output(/#{VERSION}/)
      end
    end
  end


end
