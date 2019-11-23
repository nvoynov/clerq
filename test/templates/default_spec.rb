require_relative '../spec_helper'

describe 'default.md.erb' do

  let(:template) {
    body = File.read('lib/assets/tt/default.md.erb')
    body.gsub(/^% generated by Clerq(.)*$/, '% generated by Clerq')
  }
  let(:assembly) {
    Node.new(title: 'Template spec').tap do |n|
      n << Node.new(title: 'Header')
      n << Node.new(title: 'Header with ID', id: 'h')
      n << Node.new(title: 'Metadata', meta: {source: 'spec'})
      n << Node.new(title: 'Magic Metadata', meta: {parent: 'h', order_index: '1 2'})
      n << Node.new(title: 'Body', body: 'Must not be changed [[h]]')
    end
  }
  let(:sample) {
    <<~EOF
      % Template spec
      % generated by Clerq
      % default template

      # Header

      # Header with ID

      # Metadata
      {{
      source: spec
      }}

      # Magic Metadata

      # Body

      Must not be changed [[h]]
    EOF
  }

  it 'assembly rendering must match to the sample' do
    out = Clerq::RenderErb.(erb: template, object: assembly)
    _(out).must_match sample
  end

end