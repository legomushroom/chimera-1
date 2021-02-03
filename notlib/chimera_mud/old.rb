# frozen_string_literal: true

require_relative "server/instance"
require_relative "server/socket"

module Chimera
  ##
  # The game server provides the actual connectivity for the player clients
  module Server
    def self.run(host:, port:, nats_host:, nats_port:)
      Instance.run(
        host: host,
        port: port,
        nats_host: nats_host,
        nats_port: nats_port
      )
    end
  end
end
