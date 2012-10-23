require 'thor'
require_relative 'gif'
require_relative 'command'

module Gify
  class ThorStarter < Thor
    include Thor::Actions

    desc 'create', 'convert'
    method_option :out,    type: :string,  aliases: '-o'
    method_option :delay,  type: :numeric, default: 10
    method_option :tumblr, type: :boolean, default: true
    def create(*files)
      cmd = Command::Convert.new
      cmd << "-delay #{options[:delay]}"
      cmd << '-loop 0'
      cmd << '-resize \>500' if options[:tumblr]
      cmd << files << outgif
      say cmd.to_s
      cmd.run
      say_status 'created', outgif
      check_tumblr_friendliness(outgif)
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
      def random_name
        chr = ('a'..'z').to_a
        name = ''
        5.times { name += chr.sample }
        "gify-#{name}.gif"
      end

      def outgif
        @outgif ||= begin
          out = options[:out] || random_name
          out += '.gif' unless out =~ /\.gif$/
          Gif.new out
        end
      end
    end
  end
end
