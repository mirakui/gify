require_relative 'base'
require_relative '../command'

module Gify
  module Optimizer
    class ReduceFrames < Optimizer::Base
      def optimize
        if frames.length > 0
          cmd = Command::Convert.with_options @src
          cmd << "-delete #{frames.join(',')}"
          cmd << @dst
          cmd.run
        end
      end

      def frames
        @frames ||= begin
          range = (0..@src.frames)
          range.to_a - range.step(step).to_a
        end
      end

      def step
        @options[:step] || 1
      end

      def message
        "reducing #{frames.length} of #{@src.frames} frames"
      end
    end
  end
end
