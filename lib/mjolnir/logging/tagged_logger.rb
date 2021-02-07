# frozen_string_literal: true

require "mjolnir/logging/formatter"

module Mjolnir
  module Logging
    ##
    # The tagged logger provides logging functionality and formatting for
    # Mjolnir, and attaches "tags" to help developers and admins to
    # determin what processes or threads are doing the logging
    class TaggedLogger < Logger
      delegate :tag, to: :formatter

      ##
      # @param [String] tag the tag to append to all lines for this logger
      # instance
      def initialize(tag)
        super(log_file)
        @tag = tag
        self.formatter = Formatter.new(tag)
      end

      ##
      # Creates a new tagged logger that appends the passed new tag to a new
      # logger
      #
      # @param [Strinig] new_tag the new tag to append to the existing tag
      #
      # @return [TaggedLogger] the new sub logger using the new tags
      def tagged_logger(new_tag)
        self.class.new("#{tag}.#{new_tag}")
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
