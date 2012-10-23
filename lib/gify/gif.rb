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
      size <= 1024 ** 2 && width <= 500
    end

    %w(size width height frames).each do |name|
      define_method(name) { meta[name.to_sym] }
    end

    def meta
      @meta ||= begin
        cmd = %Q(identify -format '%w,%h' #{path.to_s}[0])
        w, h = `#{cmd}`.split(',').map(&:to_i)
        cmd = %Q(identify -format '%n' #{path.to_s})
        n = `#{cmd}`.to_i
        {width: w, height: h, frames: n, size: path.size}
      end
    end
  end
end
