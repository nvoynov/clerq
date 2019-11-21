# encoding: UTF-8

module Clerq
  module Repositories

    # The class provides File and Dir functions that executed relativly path
    #   provided in constructor.
    #
    # Usage:
    #   FileRepository.new(path: Dir.pwd, pattern: '*.*')
    #   FileRepository.new(path: Dir.pwd, pattern: ['*.rb', '*.md'])
    class FileRepository
      attr_reader :path
      attr_reader :patt

      # @param path [String]
      # @param pattern [String, Array<String>]
      def initialize(path: Dir.pwd, pattern: '*.*')
        # TODO check that path exists and save it in full form
        unless Dir.exist?(path)
          msg = "'#{path}' directory does not exist!"
          raise ArgumentError, msg
        end
        @path = path
        @patt = pattern
      end

      def inside
        Dir.chdir(@path) { yield }
      end

      protected

      # @param pattern [String, Array<String>]
      def glob(pattern = '')
        pt = pattern.empty? ? @patt : pattern
        pt = [pt] if pt.is_a?(String)
        pt = pt.map{|p| p = File.join('**', p)}
        Dir.chdir(@path) { Dir.glob pt }
      end

      def read(filename)
        File.read(File.join @path, filename)
      end

      def write(filename, content)
        join = File.join(@path, filename)
        if File.exist?(join)
          errmsg = "File '#{join}' alredy exists!"
          raise StandardError, errmsg
        end
        File.write(join, content)
      end

    end

  end
end
