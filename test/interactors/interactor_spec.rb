require_relative "../spec_helper"
include Clerq::Interactors

describe Interactor do
  describe 'Success' do
    class Successful < Interactor
      def call
        @a + @b
      end

      def initialize(a: 0, b: 0)
        raise ArgumentError, "Invalid argument :a" unless a.is_a? Numeric
        raise ArgumentError, "Invalid argument :b" unless b.is_a? Numeric
        @a = a
        @b = b
      end
    end

    it 'must return value' do
      Successful.().must_equal 0
      Successful.(a: 1).must_equal 1
      Successful.(b: 1).must_equal 1
      Successful.(a: 1, b: 1).must_equal 2
    end

    it 'must raise ArgumentError when any argument invalid' do
      proc { Successful.(a: "wrong") }.must_raise ArgumentError
      proc { Successful.(b: "wrong") }.must_raise ArgumentError
    end
  end

  describe 'Failure' do
    class Failed < Interactor
      def call
        raise Failure, "Failure"
      end
    end

    it 'must raise Failure::Failure' do
      err = ->{ Failed.() }.must_raise Failed::Failure
      err.message.must_equal 'Failure'
    end
  end
end
