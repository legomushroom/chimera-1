# frozen_string_literal: true

module Mjolnir
  module Logging
    ##
    # Formatter for Mjolnir logging.
    class Formatter < Logger::Formatter
      ##
      # @return [String] tag the tag being used by the logger.
      attr_reader :tag

      ##
      # @param [String] tag the tag to append to log lines.
      def initialize(tag = nil)
        super()
        @tag = tag
      end

      def call(severity, time, _progname, msg)
        return "#{severity}, [#{time} ##{$$}] - <#{tag}> -- #{msg}\n" if tag

        "#{severity}, [#{time} ##{$$}] -- #{msg}\n"
      end
    end
  end
end
