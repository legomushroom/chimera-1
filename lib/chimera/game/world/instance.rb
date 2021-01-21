# frozen_string_literal: true

module Chimera
  module Game
    module World
      ##
      # The instance of the game world.
      class Instance
        include Nats::Common
        include Ractor::Common
        include Logging

        def initialize; end

        def start
          ensure_nats_connection
        end
      end
    end
  end
end
