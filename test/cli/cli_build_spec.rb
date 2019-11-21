require_relative '../spec_helper'

describe 'clerq build' do
  let(:content)  { "# Spec node\n# Second node" }
  let(:template) { "% <%= @object.title %>" }
  let(:another)  { "% Template" }

  def prepare_repo
    Clerq.reset
    File.write(File.join(Clerq.tt,  Clerq.template), template)
    File.write(File.join(Clerq.tt,  'another.md.erb'), another)
    File.write(File.join(Clerq.src, 'content.md'), content)
  end

  describe 'when exec without options' do
    it 'must buid document by default' do
      ClerqSandbox.() do
        prepare_repo
        Clerq::Cli.start ['build']
        out = File.join(Clerq.bin, Clerq.document + '.md')
        _(File.exists?(out)).must_equal true
      end
    end
  end

  describe 'when exec with -o output' do
    it 'must create document by -o' do
      ClerqSandbox.() do
        prepare_repo
        Clerq::Cli.start ['build', '-o', 'Other.md']
        _(File.exists?('bin/Other.md')).must_equal true
      end
    end
  end

  describe 'when exec with -t template' do
    it 'must create document using -t template' do
      ClerqSandbox.() do
        prepare_repo
        Clerq::Cli.start ['build', '-t', 'another.md.erb']
        out = File.join(Clerq.bin, Clerq.document + '.md')
        _(File.exists?(out)).must_equal true
        _(File.read(out)).must_equal '% Template'
      end
    end
  end

  describe 'when exec with -q query' do
    it 'must create document by -q query' do
      ClerqSandbox.() do
        prepare_repo
        Clerq::Cli.start ['build', '-q', "node.title == 'Second node'"]
        out = File.join(Clerq.bin, Clerq.document + '.md')
        _(File.exists?(out)).must_equal true
        _(File.read(out)).must_equal '% Second node'
      end
    end
  end

end
