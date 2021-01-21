# frozen_string_literal: true

module Chimera
  module Game
    module Server
      ##
      # Represents a connected game client
      class Socket
        include Ractor::Common

        # The logger needs to be set after the socket has been placed into the
        # ractor.
        attr_accessor :logger
        attr_reader :id

        def initialize(connection)
          @id = SecureRandom.uuid
          @connection = connection
        end

        def start
          logger.info("received connection from #{remote_ip}@#{id}")
          create_logging_ractor(connection) do |_logger, connection|
            loop do
              c = connection.readline
              c.strip!
            end
          end
        end

        private

        attr_reader :connection

        def remote_ip
          _, _, _, ip = connection.peeraddr
          ip
        end
      end
    end
  end
end
