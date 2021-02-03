# frozen_string_literal: true

require "chimera_mud/core/engine"
require "chimera_mud/core/logging"
require "chimera_mud/core/nats"
require "chimera_mud/core/ractor"
require "chimera_mud/core/plugin"

module ChimeraMud
  module Core
    def self.start(_name)
      require(File.join(Dir.pwd, "config", "environment.rb"))
      puts "Chimera MUD Engine"
      logger.info("loading plugins")
      Plugin.plugins.each do |plugin|
        logger.info("  loading #{plugin.name}")
        plugin.new
      end
    end

    def self.logger
      Logger.new($stdout)
    end
  end
end
