# frozen_string_literal: true

require "chimera/game/world/instance"

module Chimera
  module Game
    ##
    # The Game World provides the actual game interaction
    module World
      def self.start
        Instance.new.start
      end
    end
  end
end
