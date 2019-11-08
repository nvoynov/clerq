require_relative 'clerq/version'
require_relative 'clerq/entities'
require_relative 'clerq/gateways'
require_relative 'clerq/interactors'
require_relative 'clerq/repositories'
require_relative 'clerq/properties'
require_relative 'clerq/settings'
require_relative 'clerq/templater'
require_relative 'clerq/cli'

module Clerq
  class Error < StandardError; end

  class << self

    def root
      File.dirname __dir__
    end

    def gateway
      @gateway ||= Clerq::Gateways::InFiles.new
    end

    def gateway=(gateway)
      errmsg =  "Invalid argument! Clark::Gateway required"
      raise ArgumentError, errmsg unless gateway.is_a? Clerq::Gateways::Gateway
      @gateway = gateway
    end

    def settings
      @settings ||= Settings.new
    end

    def reset
      @gateway = nil
      @settings = nil
    end

  end

end
