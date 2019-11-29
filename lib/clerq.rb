require_relative 'clerq/version'
require_relative 'clerq/entities'
require_relative 'clerq/interactors'
require_relative 'clerq/services'
require_relative 'clerq/repositories'
require_relative 'clerq/properties'
require_relative 'clerq/settings'
require_relative 'clerq/render_erb'
require_relative 'clerq/cli'
include Clerq::Repositories

module Clerq
  class Error < StandardError; end

  class << self
    # TODO try forwardable there for bin, tt, title, output, etc.

    def root
      File.dirname __dir__
    end

    def settings
      @settings ||= Settings.new
    end

    def title
      settings.title
    end

    def document
      settings.document
    end

    def template
      settings.template
    end

    def bin
      settings.bin
    end

    def src
      settings.src
    end

    def tt
      settings.tt
    end

    def reset
      @settings = nil
      @node_repository = nil
      @text_repository = nil
    end

    def text_repository
      @text_repository ||= TextRepository.new(path: File.join(Dir.pwd, tt))
    end

    def text_repository=(repository)
      unless repository.is_a? TextRepository
        err = "Invalid argument. Clerq::Repositories::TextRepository required"
        raise ArgumentError, err
      end
      @text_repository = repository
    end

    def node_repository
      @node_repository ||= NodeRepository.new(path: File.join(Dir.pwd, src))
    end

    def node_repository=(repository)
      unless repository.is_a? NodeRepository
        err = "Invalid argument. Clerq::Repositories::NodeRepository required"
        raise ArgumentError, err
      end
      @node_repository = repository
    end

  end

end
