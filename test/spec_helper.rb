$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "clerq"

require "minitest/autorun"

# Provies clean folder
class Sandbox

  # Run block in sandbox folder that always empty
  # Usage
  #   Sandbox.() do
  #     File.write(file_name, content)
  #   end
  def self.call(sandbox = 'test/.sandbox')
    return unless block_given?
    Dir.mkdir(sandbox) unless Dir.exist?(sandbox)
    Dir.chdir(sandbox) do
      FileUtils.rm_rf(Dir.glob('*'))
      yield
    end
  end

  # Run block in sandbox project that always empty
  # Usage
  #   Sandbox.() do
  #     File.write(file_name, content)
  #   end
  def self.project(project = 'spec')
    return unless block_given?
    call do
      Dir.mkdir(project) unless Dir.exist?(project)
      Clerq.settings.folders.each do |f|
        # next if f.eql? Clerq.setting.assets
        Dir.mkdir(f) unless Dir.exist?(f)
        FileUtils.rm_rf(Dir.glob(File.join(f, '*')))
      end
      yield
    end
  end
end

describe Sandbox do

  it 'must provide empty sandbox' do
    Sandbox.() do
      _(Dir.glob('*')).must_equal []
      File.write('1.tmp', '1')
      File.write('2.tmp', '2')
      Dir.mkdir('1')
      Dir.mkdir('2')
      File.write('1/1.tmp', '1')
      File.write('2/2.tmp', '2')
    end
    Sandbox.() do
      _(Dir.glob('*')).must_equal []
    end
  end

  it 'must provide empty project' do
    Sandbox.project do
      File.write('bin/1.md', '1')
      File.write('src/2.md', '2')
      File.write('bin/assets/3.md', '3')
    end
    Sandbox.project do
      _(Dir.glob('*.*')).must_equal []
      _(Dir.glob('*/**')).must_equal ["bin/assets"]
    end
  end

end
