# frozen_string_literal: true

require_relative "server/instance"
require_relative "server/socket"

module Chimera
  module Game
    module Server
      def self.start(host:, port:)
        Instance.start(host: host, port: port)
      end
    end
  end
end
