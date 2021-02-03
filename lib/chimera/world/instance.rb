# frozen_string_literal: true

require "chimera/instance"

module Chimera
  module World
    class Instance < Chimera::Instance
      private

      def _start; end

      def _wait
        sleep 1 while started
      end
    end
  end
end
