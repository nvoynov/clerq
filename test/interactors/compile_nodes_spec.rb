require_relative '../spec_helper'
include Clerq::Interactors
include Clerq::Entities

describe CompileNodes do

  before do
    Clerq.gateway = Clerq::Gateways::InMemory.new
  end

  let(:gateway) { Clerq.gateway }

  let(:tt) {
    <<~EOF
    <% for @node in @object.to_a -%>
    <%= '#' * (@node.nesting_level + 1) %> [<%= @node.id%>] <%= @node.title %>
    <% end %>
    EOF
  }

  describe 'call' do
    it 'must retrive text according to template' do
      gateway.save Node.new(id: 'srs', title: "SRS")
      gateway.save Node.new(id: 'ur', title: "User requirments", meta: {parent: 'srs'})
      gateway.save Node.new(id: 'fr', title: "Func requirments", meta: {parent: 'srs'})
      gateway.save Template.new(id: 'tt', body: tt)

      text = CompileNodes.(template: 'tt')
      _(text).must_match '# [srs] SRS'
      _(text).must_match '## [ur] User requirments'
      _(text).must_match '## [fr] Func requirments'
    end

    it 'must fail when template was not provided'
    it 'must fail when query was wrong'
  end
end
