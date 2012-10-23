require 'open3'
require_relative '../gify'

module Gify
  module Command
    class Base
      class << self
        attr_accessor :command
      end
      attr_reader :command, :options

      def initialize(command=nil, *options)
        @command = command || self.class.command
        @options = options
      end

      def <<(option)
        if option.is_a?(Array)
          @options += option
        else
          @options << option
        end
        self
      end

      def run
        Gify.say_status 'run', to_s
        out, status = ::Open3.capture2e to_s
        if status != 0
          raise CommandError, "#{@command} exit(#{status}): #{out.chomp}"
        end
        Gify.say_status 'result', out.inspect
        out
      end

      def to_s
        ([@command] + @options).join(' ')
      end

      def self.with_options(*options)
        new nil, *options
      end
    end

    class Identify < Base
      self.command = 'identify'
    end

    class Convert < Base
      self.command = 'convert'
    end
  end

  class CommandError < ::StandardError; end
end
