# frozen_string_literal: true

require "chimera_mud/logging/formatter"

module ChimeraMud
  module Logging
    ##
    # The tagged logger provides logging functionality and formatting for
    # ChimeraMud, and attaches "tags" to help developers and admins to
    # determin what processes or threads are doing the logging
    class TaggedLogger < Logger
      ##
      # @param [String] tag the tag to append to all lines for this logger
      # instance
      def initialize(tag)
        super(log_file)
        @tag = tag
        self.formatter = Formatter.new(tag)
      end

      private

      def log_file
        ENV.fetch("CHIMERA_LOG_FILE", "/dev/stdout")
      end

      def level
        @level ||= ENV.fetch(
          "CHIMERA_LOG_LEVEL",
          (Rails.env.production? ? "info" : "debug")
        )
      end
    end
  end
end
