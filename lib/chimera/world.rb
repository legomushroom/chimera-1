# frozen_string_literal: true

require "chimera/world/instance"

module Chimera
  ##
  # The Game World provides the actual game interaction
  module World
    def self.start
      Instance.new.start
    end
  end
end
