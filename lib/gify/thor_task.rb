require 'thor'
require_relative '../gify'
require_relative 'gif'
require_relative 'command'

module Gify
  class ThorTask < Thor
    include Thor::Actions

    class_option :verbose, type: :boolean, aliases: '-v', default: false

    desc 'create', 'convert'
    method_option :out,    type: :string,  aliases: '-o'
    #method_option :outdir, type: :string,  default: './'
    method_option :delay,  type: :numeric, default: 10
    method_option :tumblr, type: :boolean, default: true
    def create(*infiles)
      gif = Gif.create infiles, outfile, options
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

    no_tasks do
      def random_name(prefix=nil)
        prefix ||= 'gify'
        chr = ('a'..'z').to_a
        name = ''
        5.times { name += chr.sample }
        "#{prefix}-#{name}.gif"
      end

      def outfile
        @outfile ||= begin
          out = options[:out] || random_name
          out += '.gif' unless out =~ /\.gif$/
          Pathname(out)
        end
      end

      def self.start_gify
        dispatch(nil, ARGV.dup, nil, shell: Thor::Base.shell.new) do |instance|
          Gify.thor = instance
        end
      end
    end
  end
end
