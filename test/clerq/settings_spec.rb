require_relative '../spec_helper'
include Clerq

describe Settings do

  describe 'when storage does not exist' do
    it 'must provide default properties values' do
      Sandbox.() do
        settings = Settings.new
        _(settings.bin).must_equal 'bin'
        _(settings.src).must_equal 'src'
        _(settings.tt).must_equal  'tt'
        _(settings.knb).must_equal 'knb'
        _(settings.assets).must_equal 'bin/assets'
      end
    end
  end

  describe 'when storage exists' do
    let(:storage_body) {
      <<~EOF
        ---
        document: spec
        template: spec
      EOF
    }

    it 'must read properties values from the storage' do
      Sandbox.() do
        File.write(Settings::STORAGE, storage_body)
        settings = Settings.new
        _(settings.document).must_equal 'spec'
        _(settings.template).must_equal 'spec'
      end
    end
  end

end
