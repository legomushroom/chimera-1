# frozen_string_literal: true

class ConnectionManager < ChimeraMud::Core::RactorManager

  def before_start
    create_logging_ractor(self) do |logger, manager|
      logger.info("starting TCP server")
      server = TCPServer.new("127.0.0.1", 2323)
      loop do
        logger.info("waiting for next socket")
        socket = server.accept
        manager << socket
      end
    end
  end

  def next(socket)
    plugin.socket_pipe.send(socket, move: true)
  end

  private

  attr_reader :pending_connections
end

require_relative "connection_manager/connection"
