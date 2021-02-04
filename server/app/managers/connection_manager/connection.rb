# frozen_string_literal: true

class ConnectionManager::Connection
  include ChimeraMud::Core::Logging
  include ChimeraMud::Core::Ractor::Common

  def initialize(socket)
    @socket = socket
  end

  def start
    create_logging_ractor(socket) do |logger, socket|
      loop do
        logger.info("waiting for data")
        buffer = socket.readline
        logger.info("received #{buffer.length} bytes")
      end
    end
  end

  private

  attr_reader :socket
end
