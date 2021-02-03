# frozen_string_literal: true

require "active_support/concern"

module Chimera
  module Core
    module Nats
      ##
      # Includes the common nats functionality
      module Common
        extend ActiveSupport::Concern

        def initialize(nats_host: "localhost", nats_port: "4222", **args)
          super(**args)
          @nats_host = nats_host
          @nats_port = nats_port
        end

        private

        attr_reader :nats_host, :nats_port

        def ensure_nats_connection
          Nats.ensure_connection(nats_host, nats_port)
        end
      end
    end
  end
end
