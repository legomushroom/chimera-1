# frozen_string_literal: true

require "chimera/instance"

module Chimera
  module Server
    ##
    # The Game::Server fronts the TCP access to the game and manages
    # communication between the player and the game world.
    class Instance < ChimeraMudInstance
      def initialize(host: "localhost", port: "2323", **args)
        super(**args)
        @host = host
        @port = port
        @handlers = []

        @pipe = create_pipe
      end

      def start
        Signal.trap("SIGINT") do
          stop
        end

        ensure_nats_connection
        start_server
        start_listener
        self.started = true
      end

      def run
        start
        ::Ractor.select(listener)
      end

      def stop
        pipe << :stop
      end

      private

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def start_server
        logger.info("creating server on tcp://#{host}:#{port}")
        create_logging_ractor(pipe, shutdown, host, port) do |logger, pipe, shutdown, host, port|
          logger.debug("starting server")
          server = TCPServer.open(host, port)

          ::Ractor.new(logger, shutdown, server) do |lg, sd, sv|
            sd.take
            lg.debug("stopping server")
            sv.close
          end

          logger.info("ready to accept new connections")
          loop do
            logger.debug("waiting for new connection")
            connection = server.accept
            logger.debug("new connection received, creating socket")
            socket = Socket.new(connection)
            logger.debug("socket created, accepted connection #{socket.id}")
            logger.debug("moving socket to handler")
            pipe.send(socket, move: true)
          rescue EOFError
            break
          end
        end
      end

      def start_listener
        @listener = create_logging_ractor(pipe, shutdown) do |logger, p, sd|
          loop do
            sock = p.take

            break if sock == :stop

            ::Ractor.new(logger, sock) do |l, socket|
              socket.logger = l
              socket.start
            end
          end
          logger.info("server is shutting down")
          sd << true
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      attr_reader :pipe, :host, :port, :listener
    end
  end
end
