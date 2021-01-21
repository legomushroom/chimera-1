# frozen_string_literal: true

require "active_support/concern"

module Chimera
  module Nats
    ##
    # Includes the common nats functionality
    module Common
      extend ActiveSupport::Concern

      def initialize(nats_host:, nats_port:, **args)
        super(**args)
        @nats_host = nats_host
        @nats_post = nats_port
      end

      def ensure_nats_connection
        Nats.ensure_connection
      end
    end
  end
end
