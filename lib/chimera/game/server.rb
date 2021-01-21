# frozen_string_literal: true

require_relative "server/instance"
require_relative "server/socket"

module Chimera
  module Game
    ##
    # The game server provides the actual connectivity for the player clients
    module Server
      def self.start(host:, port:)
        Instance.start(host: host, port: port)
      end
    end
  end
end
