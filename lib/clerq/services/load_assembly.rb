# encoding: UTF-8
require_relative 'service'

module Clerq
  module Services

    # The service returns assembly and prints progress in console
    class LoadAssembly < Service
      def call
        memo = {}
        on_parse_callback = lambda do |src|
          puts "Reading '#{src}'..."
          memo[src] = 0
        end
        on_error_callback = lambda do |err|
          puts "\t#{err}"
          memo[memo.keys.last] += 1
        end

        puts "Loading repository..."
        assemble = Clerq.assemble(
          on_parse: on_parse_callback,
          on_error: on_error_callback)

        if memo.empty?
          puts "This repository is empty"
        else
          errors_count = memo.values.inject(0, &:+)
          message = [].tap do |m|
            m << "#{nos(memo.size, 'file')} loaded"
            m << "#{nos(errors_count, 'error')} detected"
          end.join(', ')
          puts message
        end
        
        assemble
      end

      protected

      # TODO 0 zero, no
      def nos(number, subject)
        case number
        when 0 then "no #{subject}s"
        when 1 then "one #{subject}"
        when 2 then "two #{subject}s"
        else "#{number} #{subject}s"
        end
      end

    end

  end
end
