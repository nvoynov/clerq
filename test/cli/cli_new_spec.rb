require_relative '../spec_helper'

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

  it 'must create folder structure' do
    Sandbox.() do
      FileUtils.rm_rf(Dir.glob('*'))
      Clerq::Cli.start args
      Clerq.settings.folders.each do |f|
        _(Dir.exist?(File.join(rep, f))).must_equal true
      end
      content.each do |f|
        _(File.exist?(File.join(rep, f))).must_equal true
      end
    end
  end

  it 'must fail when project folder already exists' do
    Sandbox.() do
      FileUtils.rm_rf(Dir.glob('*'))
      Clerq::Cli.start args
      _(proc { Clerq::Cli.start args }).must_output("", /already exists!/m)
    end
  end
end
