# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Logging
    class DirectTest < ActiveSupport::TestCase
      class DirectSample
        include ChimeraMud::Logging::Direct
      end

      def test_direct_logger; end
    end
  end
end
