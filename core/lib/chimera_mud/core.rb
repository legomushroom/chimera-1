# frozen_string_literal: true

require "chimera_mud/core/engine"
require "chimera_mud/core/path_resolver"
require "chimera_mud/core/logging"
require "chimera_mud/core/nats"
require "chimera_mud/core/ractor"
require "chimera_mud/core/plugin"
require "chimera_mud/core/manager"
require "chimera_mud/core/ractor_manager"

module ChimeraMud
  module Core
    class << self
      def instantiated_plugins
        @instantiated_plugins ||= Set.new
      end

      def managers
        @managers ||= Set.new
      end

      def start(plug)
        require(File.join(Dir.pwd, "config", "environment.rb"))
        puts "Chimera MUD Engine - #{name}"
        logger.info("loading plugins")
        p = nil
        Plugin.descendants.each do |plugin|
          logger.info("  loading #{plugin.name}")
          instantiated_plugins << p = plugin.new
          next unless plugin == plug

          p.managers.each do |name, path|
            require path
            managers << name.classify.constantize.new(plugin: p)
          end
        end

        managers.each(&:before_start)

        Thread.new do
          loop do
            managers.each(&:resume)
          end
        end

        p.start
      end

      def logger
        Logger.new($stdout)
      end
    end
  end
end
