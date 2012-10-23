require 'thor'
require_relative '../gify'
require_relative 'gif'
require_relative 'command'
require_relative 'optimizer/reduce_frames'

module Gify
  module CLI
    class Optimize < Thor
      method_option :out,  type: :string,  aliases: '-o'
      method_option :step, type: :numeric, required: true
      desc 'reduce_frames', 'reduce frames'
      def reduce_frames(src)
        dst = Gify.outfile
        optimizer = Optimizer::ReduceFrames.new src, dst, options
        say_status 'optimize', optimizer.message
        optimizer.optimize
        say_status 'created', dst
      end
    end

    class Default < Thor
      include Thor::Actions

      register CLI::Optimize, 'optimize', 'optimize [command]', 'optimize gif'

      class_option :verbose, type: :boolean, aliases: '-v', default: false

      desc 'create', 'convert'
      method_option :out,    type: :string,  aliases: '-o'
      #method_option :outdir, type: :string,  default: './'
      method_option :delay,  type: :numeric, default: 10
      method_option :tumblr, type: :boolean, default: true
      def create(*infiles)
        gif = Gif.create infiles, Gify.outfile, options
        check_tumblr_friendliness(gif)
        say_status 'created', gif
      end

      desc 'check_tumblr_friendliness', 'check tumblr friendliness'
      def check_tumblr_friendliness(gif)
        gif = Gif.new gif
        say_status 'meta', gif.meta
        if gif.tumblr_friendly?
          say_status 'tumblr?', 'good', :green
        else
          say_status 'tumblr?', 'bad', :red
        end
      end
    end

    module_function
    def start
      Default.send(:dispatch, nil, ARGV.dup, nil, shell: Thor::Base.shell.new) do |instance|
        Gify.thor = instance
      end
    end
  end
end
