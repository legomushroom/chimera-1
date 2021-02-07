# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class TaggedLoggerTest < ActiveSupport::TestCase
      def test_logger_sets_formatter
        logger = TaggedLogger.new("test")

        assert_instance_of Formatter, logger.formatter
        assert_equal "test", logger.tag
      end

      def test_tagged_logger
        logger = TaggedLogger.new("test")
        sub = logger.tagged_logger("test")

        assert_equal "test.test", sub.tag
      end
    end
  end
end
