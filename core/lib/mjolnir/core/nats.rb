# frozen_string_literal: true

require "nats/io/client"

require "mjolnir/core/nats/common"

module Mjolnir
  module Core
    # @nodoc
    module Nats
      module_function

      def ensure_connection(host, port)
        return true if connection.connected?

        nats_url = "nats://#{host}:#{port}"

        Rails.logger.info("NATS connecting to #{nats_url}")
        connection.connect(servers: [nats_url])
        true
      end

      def connection
        return @connection if @connection

        @connection = NATS::IO::Client.new

        @connection
      end
    end
  end
end
