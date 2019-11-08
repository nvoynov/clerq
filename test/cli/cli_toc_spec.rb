require_relative '../spec_helper'

describe 'cli#toc' do
  let(:source) { File.join(Clerq.settings.src, 'content.md')}

  let(:content) {
    <<~EOF
      # User requirements
      ## User stories
      ## Use cases
      # Functional requirements
    EOF
  }

  let(:cmd1) { ['toc'] }
  let(:cmd2) { ['toc', '-q', "node.title == 'User stories'"] }
  let(:cmd3) { ['toc', '-q', "1 != 1"] }

  let(:out1) {
    <<~EOF
    % #{Clerq.settings.title}
    [01] User requirements
      [01.01] User stories
      [01.02] Use cases
    [02] Functional requirements
    EOF
  }

  let(:out2) {
    <<~EOF
    % User stories
    EOF
  }

  it 'must return toc' do
    Sandbox.project do
      File.write(source, content)
      {}.tap do |hsh|
        hsh[cmd1] = out1
        hsh[cmd2] = out2
        hsh[cmd3] = "% #{Clerq.settings.title}. Query: #{cmd3.last}\n"

        hsh.keys.each do |cmd|
          _(proc {Clerq::Cli.start cmd}).must_output hsh[cmd]
        end
      end

    end
  end
end
