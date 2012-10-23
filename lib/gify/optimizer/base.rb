module Gify
  module Optimizer
    class Base
      def initialize(src, dst, options={})
        @src = Gif.new src
        @dst = Gif.new dst
        @options = options
      end

      def optimize
        raise NotImplementedError
      end

      def message
        raise NotImplementedError
      end
    end
  end
end
