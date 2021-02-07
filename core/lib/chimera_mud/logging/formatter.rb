# frozen_string_literal: true

module ChimeraMud
  module Logging
    ##
    # Formatter for ChimeraMud logging.
    class Formatter < Logger::Formatter
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

      private

      attr_reader :tag
    end
  end
end
