require 'thor'
require_relative 'gif'

class Gify < Thor
  desc 'create', 'convert'
  method_option :out, :type => :string, :default => nil
  def create(*files)
    sh %Q(convert #{files.join(" ")} #{outgif})
  end

  no_tasks do
    def sh(cmd)
      say cmd, :blue
      system cmd
    end

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
