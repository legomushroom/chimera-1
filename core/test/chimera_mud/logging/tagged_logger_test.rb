# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class TaggedLoggerTest < ActiveSupport::TestCase
      def test_logger_sets_formatter
        logger = TaggedLogger.new("test")

        assert_equal logger.formatter.class, Formatter

        tag = logger.formatter.instance_variable_get(:@tag)

        assert_equal tag, "test"
      end
    end
  end
end
