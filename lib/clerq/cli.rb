# encoding: UTF-8

require 'thor'
require_relative 'services'
include Clerq::Services

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
      def thor_filename(str);
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

      def query_assembly(query)
        # TODO pretty errors ...OK, ... 1 error found, ... 2 errors found
        on_parse = lambda {|src| puts "Reading '#{src}'... "}
        on_error = lambda {|err| puts "\terror: #{err} "}
        QueryAssembly.(query: query, on_parse: on_parse, on_error: on_error)
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
        {tt: 'new/clerq.thor.tt', target: thor_filename(project)},
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
        directory('lib', File.join(Dir.pwd, 'lib'))
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
      build = File.join(Clerq.bin, document)

      node = LoadAssembly.()
      node = QueryNode.(assembly: node, query: options[:query]) if options[:query]
      text = RenderNode.(node: node, template: template)
      File.write(build, text)
      say "'#{build}' created!"
    rescue StandardError => e
      stop!(e.message)
    end

    desc "check", "Check the project for errors"
    def check
      stop_unless_clerq!
      puts "Checking assembly for writing errors..."
      CheckAssembly.(LoadAssembly.())
    end

    desc "toc [OPTIONS]", "Print the project TOC"
    method_option :query, aliases: "-q", type: :string, desc: "Query"
    def toc
      stop_unless_clerq!
      node = LoadAssembly.()
      node = QueryNode.(assembly: node, query: options[:query]) if options[:query]
      puts "% #{node.title}"
      puts "% #{node[:query]}" if node[:query]
      node.to_a.drop(1).each{|n|
        puts  "#{'  ' * (n.nesting_level - 1)}[#{n.id}] #{n.title}"
      }
    rescue StandardError => e
      stop!(e.message)
    end

    desc "node ID [TITLE]", "Create a new node"
    method_option :template, aliases: "-t", type: :string, desc: "template"
    def node(id, title = '')
      stop_unless_clerq!
      fn = CreateNode.(id: id, title: title, template: options[:template] || '')
      say "'#{fn}' created"
    rescue StandardError => e
      stop!(e.message)
    end

  end
end
