# frozen_string_literal: true

require "singleton"

module Chimera
  module Game
    ##
    # The Game::Server fronts the TCP access to the game and manages
    # communication between the player and the game world.
    module Server
      class Instance
        def self.start(host:, port:)
          new(host, port).start
        end

        def initialize(host, port)
          @host = host
          @port = port
          @listener = TCPServer.open(host, port)
          @handlers = []

          @handler_pipe = Ractor.new do
            loop do
              Ractor.yield(Ractor.receive, move: true)
            end
          end

          @server_pipe = Ractor.new do
            loop do
              Ractor.yield(Ractor.receive, move: true)
            end
          end
        end

        def start
          Rails.logger.debug("waiting for connections")
          Rails.logger.debug("creating server on tcp://#{host}:#{port}")
          loop do
            handler = Ractor.new(handler_pipe, server_pipe) do |hp, _sp|
              s = hp.take
              s.start
              puts "tooken"
            end

            server = Ractor.new(server_pipe, handler_pipe) do |sp, hp|
              s = sp.take
              connection = s.accept
              socket = Socket.new(connection)
              hp.send(socket, move: true)
            end
          end
        end

        private

        attr_reader :pipe, :host, :port, :handlers, :server, :handler_pipe, :server_pipe, :listener
      end
    end
  end
end
