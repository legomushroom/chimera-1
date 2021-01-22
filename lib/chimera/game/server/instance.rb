# frozen_string_literal: true

require "singleton"

module Chimera
  module Game
    module Server
      ##
      # The Game::Server fronts the TCP access to the game and manages
      # communication between the player and the game world.
      class Instance
        attr_reader :started

        include Logging
        include Ractor::Common
        include Nats::Common

        def self.start(host:, port:)
          new(host, port).start
        end

        def initialize(host: "localhost", port: "2323", **args)
          super(**args)
          @host = host
          @port = port
          @handlers = []

          @pipe = create_pipe
        end

        def start
          ensure_nats_connection
          start_server

          @started = true
          until @stopped
            sock = pipe.take

            create_logging_ractor(sock) do |logger, socket|
              socket.logger = logger
              socket.start
            end
          end

          @started = false
        end

        def stop
          @stopped = false
        end

        private

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def start_server
          Rails.logger.info("creating server on tcp://#{host}:#{port}")
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

        attr_reader :pipe, :host, :port, :handlers
      end
    end
  end
end
