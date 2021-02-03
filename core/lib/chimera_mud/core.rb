# frozen_string_literal: true

require "chimera_mud/core/engine"
require "chimera_mud/core/logging"
require "chimera_mud/core/nats"
require "chimera_mud/core/ractor"
require "chimera_mud/core/plugin"

module ChimeraMud
  module Core
    def self.instantiated_plugins
      @instantiated_plugins ||= Set.new
    end

    def self.managers
      @managers ||= {}
    end

    def self.start(name)
      require(File.join(Dir.pwd, "config", "environment.rb"))
      puts "Chimera MUD Engine - #{name}"
      logger.info("loading plugins")
      Plugin.descendants.each do |plugin|
        logger.info("  loading #{plugin.name}")
        instantiated_plugins << p = plugin.new
        p.load_managers_for(name).each do |manager|
          managers[manager.name] = manager
        end
      end
    end

    def self.logger
      Logger.new($stdout)
    end
  end
end
