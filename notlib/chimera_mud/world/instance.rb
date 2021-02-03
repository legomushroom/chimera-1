# frozen_string_literal: true

require "chimera/instance"

module Chimera
  module World
    ##
    # The Game::World::Instance is the primary world process that runs the game
    # world.
    class Instance < ChimeraMudInstance
      private

      def _start; end

      def _wait
        sleep 1 while started
      end
    end
  end
end
