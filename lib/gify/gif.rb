require 'pathname'

module Gify
  class Gif
    attr_reader :path

    def initialize(path)
      @path = Pathname(path.to_s)
    end

    def to_s
      @path.to_s
    end

    def tumblr_friendly?
      size <= 1024 ** 2 && width <= 500 && height <= 700
    end

    %w(size width height frames).each do |name|
      define_method(name) { meta[name.to_sym] }
    end

    def meta
      @meta ||= begin
        cmd = Command::Identify.with_options "-format '%w,%h'", "#{path}[0]"
        w, h = cmd.run.split(',').map(&:to_i)
        cmd = Command::Identify.with_options "-format '%n'", path
        n = cmd.run.to_i
        {width: w, height: h, frames: n, size: path.size}
      end
    end
  end
end
