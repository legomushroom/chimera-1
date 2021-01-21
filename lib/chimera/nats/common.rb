# frozen_string_literal: true

require "active_support/concern"

module Chimera
  module Nats
    ##
    # Includes the common nats functionality
    module Common
      extend ActiveSupport::Concern

      def ensure_nats_connection
        Nats.ensure_connection
      end
    end
  end
end
