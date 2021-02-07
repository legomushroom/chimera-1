# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class TaggedLoggerTest < ActiveSupport::TestCase
      def test_logger_sets_formatter
        logger = TaggedLogger.new("test")

        assert_equal logger.formatter.class, Formatter
        assert_equal logger.tag, "test"
      end

      def test_tagged_logger
        logger = TaggedLogger.new("test")
        sub = logger.tagged_logger("test")

        assert_equal sub.tag, "test.test"
      end
    end
  end
end
