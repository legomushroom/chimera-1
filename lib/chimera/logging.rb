# frozen_string_literal: true

require "active_support/concern"

module Chimera
  ##
  # Adds the logger method. Useful for things that use RactorCommon
  module Logging
    extend ActiveSupport::Concern

    def logger
      Rails.logger
    end
  end
end
