require_relative '../spec_helper'
include Clerq

describe Properties do
  class Form
    extend Properties
    property :a
    property :b, default: 'b'
    property :c, &Proc.new{|v| v.is_a? Numeric}
  end

  let(:form) { Form.new }

  describe '#property' do
    it 'must define getter and setter' do
      _(form).must_respond_to :a
      _(form).must_respond_to :a=
      _(form).must_respond_to :b
      _(form).must_respond_to :b=
      _(form).must_respond_to :c
      _(form).must_respond_to :c=
    end

    it 'getter must return default value when it provided' do
      _(form.b).must_equal 'b'
      form.b = 'new value'
      _(form.b).must_equal 'new value'
    end

    it 'must validate value' do
      form.c = 25
      _(proc { form.c = "bla-bla-bla" }).must_raise ArgumentError
    end

  end

  module Parameters
    extend Properties
    extend self

    property :format, default: 'docx'
    property :title,  default: 'SRS', &Proc.new{|v| v.is_a? String}
  end

  describe 'Parameters' do
    it 'must extend wit properties' do
      _(Parameters).must_respond_to :format
      _(Parameters).must_respond_to :format=
      _(Parameters).must_respond_to :title
      _(Parameters).must_respond_to :title=

      _(Parameters.format).must_equal 'docx'
      _(Parameters.title).must_equal 'SRS'
      Parameters.title = "SRS1"
      _(proc { Parameters.title = 25 }).must_raise ArgumentError
    end
  end

end
