require_relative '../spec_helper'
include Clerq::Gateways

describe InMemory do

  let(:gateway) { InMemory.new }

  it 'must respond_to? :save' do
    gateway.must_respond_to :save
  end

end
