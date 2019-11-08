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
      form.must_respond_to :a
      form.must_respond_to :a=
      form.must_respond_to :b
      form.must_respond_to :b=
      form.must_respond_to :c
      form.must_respond_to :c=
    end

    it 'getter must return default value when it provided' do
      form.b.must_equal 'b'
      form.b = 'new value'
      form.b.must_equal 'new value'
    end

    it 'must validate value' do
      form.c = 25
      proc { form.c = "bla-bla-bla" }.must_raise ArgumentError
    end

    it 'must provide instance_variables'
  end

  module Parameters
    extend Properties
    extend self

    property :format, default: 'docx'
    property :title,  default: 'SRS', &Proc.new{|v| v.is_a? String}
  end

  describe 'Parameters' do
    it 'must be as class?' do
      Parameters.must_respond_to :format
      Parameters.must_respond_to :format=
      Parameters.must_respond_to :title
      Parameters.must_respond_to :title=

      Parameters.format.must_equal 'docx'
      Parameters.title.must_equal 'SRS'
      Parameters.title = "SRS1"
      proc { Parameters.title = 25 }.must_raise ArgumentError
    end
  end

end
