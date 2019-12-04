require_relative '../spec_helper'
include Clerq::Services

describe LoadAssembly do

  let(:sources) {
    {
      'f1.md' => '# no errors',
      'f2.md' => 'wrong first line',
      'f3.md' => "# no errors\n### wrong level",
      'f4.md' => "## wrong level\n## wrong level\n## wrong level"
    }
  }

  let(:output) {
    <<~EOF
      Loading repository...
      Reading 'f1.md'...
      Reading 'f2.md'...
      \tinvalid node format: wrong first line
      Reading 'f3.md'...
      \tinvalid header level: ### wrong level
      Reading 'f4.md'...
      \tinvalid header level: ## wrong level
      4 files loaded, 3 errors detected
    EOF
  }

  it 'must print reading progress info' do
    Sandbox.() do
      repo = Clerq::Repositories::NodeRepository.new
      Clerq.node_repository = repo

      _(proc{LoadAssembly.()}).must_output "Loading repository...\nThis repository is empty\n", ""

      sources.each{|file, content| File.write(file, content)}
      _(proc{LoadAssembly.()}).must_output output, ""
    end
  end

end
