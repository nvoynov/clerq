require_relative '../spec_helper'
include Clerq

describe Settings do

  it 'must provide default values when storage does not exist' do
    Sandbox.() do
      File.delete(Settings::STORAGE) if File.exist?(Settings::STORAGE)
      settings = Settings.new
      _(settings.bin).must_equal 'bin'
      _(settings.src).must_equal 'src'
      _(settings.tt).must_equal  'tt'
      _(settings.knb).must_equal 'knb'
      _(settings.assets).must_equal 'bin/assets'
    end
  end

  let(:default) {
<<~EOF
---
  binary_name: Clеrk SRS
  binary_title: Clerq. Software Requirements Specification
  binary_template: default.md.erb.tt
  bin: bin
  src: src
  knb: knb
  lib: lib
  tt: tt
  assets: bin/assets
EOF
  }

  let(:changed) {
<<~EOF
  binary_name: Clеrk SRS
  binary_title: Clerq. Software Requirements Specification
  binary_template: default.md.erb.tt
  bin: abin
  src: asrc
  knb: aknb
  lib: alib
  tt: tt
  assets: bin/assets
EOF
  }

  it 'must read settings from storage' do
    Sandbox.() do
      File.write(Settings::STORAGE, changed)
      settings = Settings.new
      _(settings.bin).must_equal 'abin'
      _(settings.src).must_equal 'asrc'
      _(settings.knb).must_equal 'aknb'
    end
  end

  it 'must save settings to storage' do
    Sandbox.() do
      File.delete(Settings::STORAGE) if File.exist?(Settings::STORAGE)
      settings = Settings.new
      settings.bin = 'aabin'
      settings.save
      content = File.read(Settings::STORAGE)
      _(content).must_equal <<~EOF
        ---
        bin: aabin
      EOF
    end
  end

end
