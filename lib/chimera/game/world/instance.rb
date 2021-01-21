# frozen_string_literal: true

module Chimera
  module Game
    module World
      ##
      # The instance of the game world.
      class Instance
        def initialize; end

        def start
          Nats.ensure_connection
        end
      end
    end
  end
end
