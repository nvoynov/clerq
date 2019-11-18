# encoding: UTF-8

require 'pp'
require 'yaml'
require_relative 'properties'

module Clerq

  class Settings
    extend Properties

    STORAGE = 'clerq.yml'.freeze

    # binary document settings that can be changed through 'clerq.yml'
    property :document, default: 'Clеrq SRS'
    property :template, default: 'default.md.erb'
    property :title, default: 'Clеrq SRS'

    # folders structure
    property :bin, default: 'bin'
    property :src, default: 'src'
    property :knb, default: 'knb'
    property :lib, default: 'lib'
    property :tt,  default: 'tt'
    property :assets, default: 'bin/assets'

    def folders
      [bin, src, knb, lib, tt, assets]
    end

    def initialize
      load
    end

    # TODO: load settings than can be changed by user
    def load
      return unless File.exist?(STORAGE)

      props = YAML.load(File.read(STORAGE))
      props.each{|k, v| instance_variable_set("@#{k}", v) }
    end

    # TODO: it saves only changed properties
    #       properties with default values won't be saved
    def save
      props = {}
      instance_variables.each{|v|
        # props[v.to_s[1..-1]] = instance_variable_get("#{v}")
        p = v.to_s[1..-1]
        props[p] = self.send(p)
      }
      File.write(STORAGE, YAML.dump(props))
    end
  end

end
