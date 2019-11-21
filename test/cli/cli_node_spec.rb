require_relative '../spec_helper'

describe 'clerq node' do

  before { Clerq.reset }

  it 'must create node' do
    ClerqSandbox.() do
      Clerq::Cli.start ['node', 'id', 'title']
      text = File.read(File.join(Clerq.src, 'id.md'))
      _(text).must_match <<~EOF
        # [id] title
      EOF
    end
  end

  describe 'when template option provided' do
    let(:tf) { File.join(Clerq.tt, 'spec.md.tt') }
    let(:tb) { "This body from 'spec'" }
    let(:id) { 'id' }
    let(:nf) { File.join(Clerq.src, "#{id}.md") }

    it 'must create node with body from the template' do
      ClerqSandbox.() do
        File.write(tf, tb)
        Clerq::Cli.start ['node', 'id', 'title', '-t', 'spec']
        text = File.read(nf)
        _(text).must_match <<~EOF
          # [id] title
          
          #{tb}
        EOF
      end
    end
  end

end
