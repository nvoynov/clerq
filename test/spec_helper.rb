$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "clerq"

require "minitest/autorun"

class Sandbox
  def self.call
    Dir.mktmpdir(['clerq']){|dir| Dir.chdir(dir) { yield }}
  end
end

class ClerqSandbox
  def self.call
    Dir.mktmpdir(['clerq']) do |dir|
      Dir.chdir(dir) do
        Clerq.settings.folders.each{|d| Dir.mkdir(d)}
        yield
      end
    end
  end
end
