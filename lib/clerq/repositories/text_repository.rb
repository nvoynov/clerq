# encoding: UTF-8
require_relative 'file_repository'

module Clerq
  module Repositories

    class TextRepository < FileRepository

      def initialize(path: Dir.pwd, pattern: ['*.md.erb', '*.md.tt'])
        super(path: path, pattern: pattern)
      end

      # Return template body @param name [String]
      def text(name)
        filename = find(name)
        if filename.empty?
          err = "File '#{name}' not found"
          raise StandardError, err
        end
        read(filename)
      end

      # def find(filename)
      #   inside do
      #     return filename if File.exist?(filename)
      #     @patt.each do |p|
      #       fn = "#{filename}#{p[1..-1]}"
      #       return fn if File.exist?(fn)
      #     end
      #   end
      #   ''
      # end

      def find(name)
        inside {
          return name if File.exist?(name) and !File.directory?(name)}
        all = glob
        pos = @patt.map{|p| "#{name}#{p[1..-1]}"}.unshift(name)
        all.find(lambda {''}){|n|
          pos.include?(n) || n.start_with?(*pos) || n.end_with?(*pos)
        }
      end

    end

  end
end
