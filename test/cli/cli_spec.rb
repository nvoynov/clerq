require_relative '../spec_helper'
include Clerq

describe Cli do

  before { Clerq.reset }

  describe '#version' do

    let(:cmd) {[
      Proc.new {Cli.start ['-v']}, Proc.new {Cli.start ['--version']}
    ]}

    it 'must return current version' do
      cmd.each{|c| _(proc{ c.call }).must_output(/#{VERSION}/)}
    end
  end

  describe 'when node, toc, check, build exec outside clerq project' do
    let(:commands) {[['node', 'id'], ['toc'], ['check'], ['build']]}

    it 'must stop and print appropriate message' do
      commands.each do |c|
        cmd = ->{Clerq::Cli.start c}
        _(proc{ cmd.call }).must_output "", /Clerq project required!/
      end
    end
  end

  describe 'clerq toc' do

    describe 'when called without parameters' do
      it 'must print % title' do
        ClerqSandbox.() do
          cmd = ->{Clerq::Cli.start ['toc']}
          _(proc{ cmd.call }).must_output(/% #{Clerq.title}\n/, "")
        end
      end
    end

    describe 'when called with query' do
      let(:query) { '1 != 1' }
      let(:output) {
        <<~EOF
          % #{Clerq.title}
          % #{query}
        EOF
      }

      it 'must print % query' do
        ClerqSandbox.() do
          cmd = ->{ Clerq::Cli.start ['toc', '-q', query] }
          _(proc{ cmd.call }).must_output(%r[#{output}], "")
        end
      end
    end
  end

end
