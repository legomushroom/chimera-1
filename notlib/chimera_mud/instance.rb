# frozen_string_literal: true

module Chimera
  class Instance
    include Nats::Common
    include Ractor::Common
    include Logging

    def initialize(**args)
      super(**args)

      @shutdown = create_pipe
    end

    def start
      Signal.trap("SIGINT") do
        stop
      end

      ensure_nats_connection
      _start
      self.started = true
    end

    def run
      start
      _wait
    end

    def stop
      _stop
      shutdown << :stop
      self.started = false
    end

    private

    attr_reader :shutdown
    attr_accessor :started

    def _stop; end

    def _start
      raise NotImplementedError
    end

    def _wait
      raise NotImplementedError
    end
  end
end
