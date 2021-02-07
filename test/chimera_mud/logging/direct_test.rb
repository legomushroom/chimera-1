# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class DirectTest < ActiveSupport::TestCase
      class DirectSample
        include ChimeraMud::Logging::Direct

        log_tag "direct-sample"

        def logger
          super
        end
      end

      def test_direct_logger_instance
        sample = DirectSample.new

        assert_instance_of TaggedLogger, sample.logger
      end

      def test_direct_logger_class
        assert_instance_of TaggedLogger, DirectSample.logger
      end

      def test_direct_logger_tag
        sample = DirectSample.new

        assert_equal "direct-sample", sample.logger.tag
        assert_equal "direct-sample", DirectSample.logger.tag
      end
    end
  end
end
