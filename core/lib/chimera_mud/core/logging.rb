# frozen_string_literal: true

require "active_support/concern"

module ChimeraMud
  module Core
    ##
    # Adds the logger method. Useful for things that use RactorCommon
    module Logging
      extend ActiveSupport::Concern

      def logger
        @logger ||= Logger.new($stdout)
      end
    end
  end
end
