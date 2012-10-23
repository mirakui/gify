module Gify
  module Tumblr
    class Validator
      attr_reader :errors

      def initialize(gif)
        @gif = gif
        @errors = []
      end

      def validators
        @validators ||= [
          MaxFileSize.new(@gif.size),
          MaxWidth.new(@gif.width),
          MaxHeight.new(@gif.height)
        ]
      end

      def valid?
        @errors = validators.select {|validator| !validator.valid? }
        @errors.empty?
      end

      class Base
        def initialize(value)
          @value = value
        end
      end

      class MaxBase < Base
        def valid?
          threshold >= @value
        end

        def message
          "#{self.class.name.sub(/^.*Max/, '')} must be within #{threshold} but was #{@value}"
        end

        def self.threshold=(th)
          threshold = th
        end
      end

      class MaxFileSize < MaxBase
        def threshold; 1024 ** 2 end
      end

      class MaxWidth < MaxBase
        def threshold; 500 end
      end

      class MaxHeight < MaxBase
        def threshold; 700 end
      end
    end
  end
end
