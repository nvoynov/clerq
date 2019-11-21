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

    no_commands {
      # @param [String]
      # @returns [String] usual name for ruby file
      def thor_file_name(str);
        str.split(/[\W+_]/).map(&:downcase).join('_') + '.thor'
      end

      # @param [String]
      # @returns [String] usual name for ruby class
      def ruby_class_name(str);
        str.split(/[\W+_]/).map(&:capitalize).join
      end

      def clerq_project?
        File.exist?(Clerq::Settings::STORAGE) || Dir.exist?(Clerq.settings.src)
      end

      def stop_unless_clerq!
        stop! "Clerq project required!" unless clerq_project?
      end

      def stop!(msg)
        raise Thor::Error, msg
      end
    }

    desc "new PROJECT", "Create a new Clerq project"
    def new(project)
      stop! "'#{project}' folder already exists!" if Dir.exist?(project)
      say "Creating project '#{project}'..."

      settings = Clerq.settings
      tts = [
        {tt: 'new/README.md.tt', target: 'README.md'},
        {tt: 'new/clerq.yml.tt', target: Clerq::Settings::STORAGE},
        {tt: 'new/clerq.thor.tt', target: thor_file_name(project)},
        {tt: 'new/content.md.tt', target: File.join(settings.src, "#{project}.md")}
      ]

      config = {project: project, klass: ruby_class_name(project)}

      Dir.mkdir(project)
      Dir.chdir(project) do
        settings.folders.each{|f| Dir.mkdir(f)}
        tts.each do |tt|
          template(tt[:tt], File.join(Dir.pwd, tt[:target]), config)
        end
        directory('tt', File.join(Dir.pwd, 'tt'))
        say "Project created!"
      end
    end

    desc "promo", "Copy content of promo project"
    def promo
      say "Copying promo content ..."
      directory('promo', Dir.pwd)
      say "Copied!"
    end

    desc "build [OPTIONS]", "Build the clerq project"
    method_option :query, aliases: "-q", type: :string, desc: "query"
    method_option :tt, aliases: "-t", type: :string, desc: "template"
    method_option :output, aliases: "-o", type: :string, desc: "output file"
    def build
      stop_unless_clerq!
      document = options[:output] || Clerq.document + '.md'
      template = options[:tt] || Clerq.template
      query = options[:query] || ''
      build = File.join(Clerq.bin, document)
      content = RenderAssembly.(template: template, query: query)
      File.write(build, content)
      say "'#{build}' created!"
    rescue RenderAssembly::Failure => e
      stop!(e.message)
    end

    desc "check", "Check the project for errors"
    def check
      stop_unless_clerq!
      errors = CheckAssembly.()
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
    rescue CheckAssembly::Failure => e
      stop!(e.message)
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
      stop_unless_clerq!
      # smells! smells! smells!
      # TODO interactor must return file name
      # TODO must not check if file exists - it task of repository
      file = File.join(Clerq.src, "#{id}.md")
      stop!("File already exists #{fn}") if File.exist?(file)
      template = options[:template] || ''
      CreateNode.(id: id, title: title, template: template)
      say "'#{file}' created"
    rescue CreateNode::Failure => e
      stop!(e.message)
    end

    desc "toc [OPTIONS]", "Print the project TOC"
    method_option :query, aliases: "-q", type: :string, desc: "Query"
    def toc
      stop_unless_clerq!
      node = QueryAssembly.(options[:query] || '')
      puts "% #{node.title}"
      puts "% #{node[:query]}" if node[:query]
      node.to_a.drop(1).each{|n|
        puts  "#{'  ' * (n.nesting_level - 1)}[#{n.id}] #{n.title}"
      }
    rescue QueryAssembly::Failure => e
      stop!(e.message)
    end

  end
end
