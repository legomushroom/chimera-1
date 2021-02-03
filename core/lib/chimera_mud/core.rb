# frozen_string_literal: true

require "chimera_mud/core/version"
require "chimera_mud/core/engine"
require "chimera_mud/core/logging"
require "chimera_mud/core/nats"
require "chimera_mud/core/ractor"

module ChimeraMud
  module Core
    def self.start(_name)
      puts "Chimera MUD Engine"
      puts "   Application Root"
      logger.info("loading plugins")
      Plugin.plugins.each do |plugin|
        logger.info("  loading #{plugin.name}")
        plugin.new
      end
    end

    def self.logger
      Rails.logger
    end
  end
end
