# frozen_string_literal: true

require "nats/io/client"

require "chimera/logging"

module Chimera
  ##
  # Include common NATS functionality
  module Nats
    module_function

    def ensure_connection
      return true if connection.connected?

      nats_url = "nats://#{ENV['CHIMERA_NATS_HOST'] || '127.0.0.1'}:" +
                 (ENV["CHIMERA_NATS_PORT"] || "4222")

      Rails.logger.info("NATS connecting to #{nats_url}")
      connection.connect(servers: [nats_url])
      true
    end

    def connection
      return @connection if @connection

      @connection = NATS::IO::Client.new

      @connection.on_error do |error|
        Rails.logger.error(error)
      end

      @connection
    end
  end
end
