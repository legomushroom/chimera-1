# frozen_string_literal: true

require "singleton"

module Chimera
  module Server
    ##
    # The Game::Server fronts the TCP access to the game and manages
    # communication between the player and the game world.
    class Instance
      attr_accessor :started

      include Logging
      include Ractor::Common
      include Nats::Common

      def self.start(host:, port:, nats_host:, nats_port:)
        new(
          host: host,
          port: port,
          nats_host: nats_host,
          nats_port: nats_port
        ).start
      end

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
        puts "listener started"
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
        create_logging_ractor(pipe, host, port) do |logger, pipe, host, port|
          logger.debug("starting server")
          server = TCPServer.open(host, port)
          loop do
            connection = server.accept
            socket = Socket.new(connection)
            logger.debug("accepted connection #{socket.id}")
            pipe.send(socket, move: true)
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def start_listener
        @listener = create_logging_ractor(pipe) do |logger, p|
          loop do
            sock = p.take

            break if sock == :stop

            ::Ractor.new(logger, sock) do |l, socket|
              socket.logger = l
              socket.start
            end
          end
        end
      end

      attr_reader :pipe, :host, :port, :listener
    end
  end
end
