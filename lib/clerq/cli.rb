# encoding: UTF-8

require 'thor'
require_relative 'interactors'
include Clerq::Interactors

module Clerq

  class Cli < Thor
    include Thor::Actions
    namespace :clerq

    def self.source_root
      File.join Clerq.root, "lib/assets"
    end

    desc "--version, -v", "Print the version"
    def version
      puts "Clerq v#{Clerq::VERSION}"
    end
    map %w[--version -v] => :version

    desc "new PROJECT", "Create a new Clerq project"
    def new(project)
      say "Creating project '#{project}'..."

      if Dir.exist?(project)
        error "Directory '#{project}' already exists!"
        return
      end

      settings = Clerq.settings
      tts = [
        {tt: 'new/README.md.tt', target: 'README.md'},
        {tt: 'new/clerq.yml.tt', target: 'clerq.yml'},
        {tt: 'new/clerq.thor.tt', target: "#{project}.thor"},
        {tt: 'new/content.md.tt', target: File.join(settings.src, "#{project}.md")}
      ]

      Dir.mkdir(project)
      Dir.chdir(project) do
        settings.folders.each{|f| Dir.mkdir(f)}
        tts.each do |tt|
          template(tt[:tt], File.join(Dir.pwd, tt[:target]), {project: project})
        end
        directory('tt', File.join(Dir.pwd, 'tt'))
        say "Project created!"
      end
    end

    desc "promo", "Copy content of promo project"
    def promo
      say "Copying promo content ..."
      directory('promo', Dir.pwd)
    end

    desc "build [OPTIONS]", "Build the clerq project"
    method_option :query, aliases: "-q", type: :string, desc: "query"
    method_option :tt, aliases: "-t", type: :string, desc: "template"
    method_option :output, aliases: "-o", type: :string, desc: "output file"
    def build
      settings = Clerq.settings
      document = options[:output] || settings.document + '.md'
      template = options[:tt] || settings.template
      query = options[:query] || ''
      build = File.join(settings.bin, document)
      content = CompileNodes.(template: template, query: query)
      File.write(build, content)
      say "'#{build}' created!"
    rescue CompileNodes::Failure => e
      error e.message
    end

    desc "check", "Check the project for errors"
    def check
      errors = CheckNodes.()
      if errors.empty?
        say "No errors found"
        return
      end

      CHECK_MESSAGES.each do |key, msg|
        if errors.key?(key)
          say "The following #{msg[0]}:"
          errors[key].each{|k,v| say "\t#{k}\t#{msg[1]} #{v.join(', ')}"}
        end
      end
    rescue CheckNodes::Failure => e
      error e.message
    end

    CHECK_MESSAGES = {
      nonuniq_ids: ['node identifiers are non-uniqe', 'in'],
      unknown_parents: ['meta[:parent] not found', 'in'],
      unknown_references: ['links are unknown', 'in'],
      unknown_order_index: ['node meta[:order_index] unknown', ':']
    }.freeze

    desc "node ID [TITLE]", "Create a new node"
    method_option :template, aliases: "-t", type: :string, desc: "template"
    def node(id, title = '')
      settings = Clerq.settings
      file = File.join(settings.src, "#{id}.md")
      if File.exist?(file)
        error "File already exists #{fn}"
        return
      end
      template = options[:template] || ''
      CreateNode.(id: id, title: title, template: template)
      say "'#{file}' created"
    rescue CreateNode::Failure => e
      error e.message
    end

    desc "toc [OPTIONS]", "Print the project TOC"
    method_option :query, aliases: "-q", type: :string, desc: "Query"
    def toc
      query = options[:query]
      node = query ? QueryNodes.(query: query) : JoinNodes.()
      puts "% #{node.title}"
      node.to_a.drop(1).each{|n|
        puts  "#{'  ' * (n.nesting_level - 1)}[#{n.id}] #{n.title}"
      }
    rescue QueryNodes::Failure, JoinNodes::Failure => e
      error e.message
    end

  end
end
