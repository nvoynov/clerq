require_relative 'spec_helper'

describe Clerq do
  it 'must have version number' do
    _(Clerq::VERSION).wont_be_nil
  end

  it 'must respond_to :settings' do
    _(Clerq).must_respond_to :settings
    _(Clerq.settings.bin).must_equal 'bin'
  end

  it 'must respond_to :gateway' do
    _(Clerq).must_respond_to :gateway
    _(Clerq).must_respond_to :gateway=
  end
end
