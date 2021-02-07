# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class FormatterTest < ActiveSupport::TestCase
      def test_call_returns_untagged_line
        formatter = Logging::Formatter.new

        Timecop.freeze(Time.parse("2020-12-01")) do
          msg = formatter.call("DEBUG", Time.now, "foo", "themessage")
          assert_equal msg, "DEBUG, [2020-12-01 00:00:00 +0000 ##{$$}]"\
            " -- themessage\n"
        end
      end

      def test_call_returns_tagged_line
        formatter = Logging::Formatter.new("test")

        Timecop.freeze(Time.parse("2020-12-01")) do
          msg = formatter.call("DEBUG", Time.now, "foo", "themessage")
          assert_equal msg, "DEBUG, [2020-12-01 00:00:00 +0000 ##{$$}]"\
            " - <test> -- themessage\n"
        end
      end
    end
  end
end
