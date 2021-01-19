# frozen_string_literal: true

module Chimera
  module Game
    module Server
      class Socket
        attr_reader :id

        def initialize(connection)
          @id = SecureRandom.uuid
          @connection = connection
        end

        def start
          Rails.logger.info("received connection from #{remote_ip}")
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
