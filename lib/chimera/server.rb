# frozen_string_literal: true

require_relative "server/instance"
require_relative "server/socket"

module Chimera
  ##
  # The game server provides the actual connectivity for the player clients
  module Server
    def self.start(host:, port:, nats_host:, nats_port:)
      Instance.start(
        host: host,
        port: port,
        nats_host: nats_host,
        nats_port: nats_port
      )
    end
  end
end
