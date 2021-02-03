# frozen_string_literal: true

module Chimera
  module Core
    class Plugin
      def self.plugins
        @plugins ||= Set.new
      end

      def self.inherited(child)
        super
        @plugins << child
      end
    end
  end
end
