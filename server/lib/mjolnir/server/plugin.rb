# frozen_string_literal: true

module Mjolnir
  module Server
    class Plugin < Mjolnir::Core::Plugin
      include Core::Ractor::Common

      attr_reader :socket_pipe

      def initialize
        super
        @socket_pipe = create_pipe
      end

      def start
        loop do
          socket = socket_pipe.take
          ConnectionManager::Connection.new(socket).start
        end
      end
    end
  end
end
