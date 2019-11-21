require_relative '../spec_helper'
include Clerq

describe 'clerq new' do

  let(:cmd) { 'new' }
  let(:rep) { 'rep' }
  let(:args) { [cmd, rep] }
  let(:content) {
    [
      "#{rep}.thor",
      'README.md',
      'clerq.yml',
      File.join(Clerq.settings.src, "#{rep}.md"),
      File.join(Clerq.settings.tt, 'default.md.erb')
    ]
  }

  it 'must fail when project folder already exists' do
    Sandbox.() do
      Clerq::Cli.start args
      _(proc { Clerq::Cli.start args }).must_output("", /already exists!/m)
    end
  end

  it 'must create folder structure' do
    Sandbox.() do
      Cli.start args
      Clerq.settings.folders.each do |f|
        _(Dir.exist?(File.join(rep, f))).must_equal true
      end
      content.each do |f|
        _(File.exist?(File.join(rep, f))).must_equal true
      end
    end
  end

  describe 'when project parameter is few words' do
    let(:project)  { 'Clerq Promo' }
    let(:filename) { File.join(project, 'clerq_promo.thor') }
    let(:thorname) { 'class ClerqPromo < Thor' }

    it 'must create pretty .thor file' do
      Sandbox.() do
        Cli.start ['new', project]
        _(File.exist?(filename)).must_equal true
        _(File.read(filename)).must_match thorname
      end
    end
  end


end
