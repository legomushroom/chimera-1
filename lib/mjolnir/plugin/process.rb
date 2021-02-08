# frozen_string_literal: true

module Mjolnir
  module Plugin
    ##
    # Process plugins are meant to be started as a core game process. These
    # plugins are responsible for loading and handling managers. Mjolnir
    # depends on two Process plugins out of the box, the `server` plugin and
    # the `world` plugin.
    #
    # Process plugins are started by calling `Mjolnir::start` and passing
    # in the plugin as the only argument.
    #
    # Process plugins will automatically load all managers based on it's name.
    # See `Mjolnir::Manager` for more details on managers.
    class Process < Base
      attr_accessor :manager

      def initialize
        super
        @managers = Support::PathResolver.new(
          plugin: self,
          app_dir: "managers",
          glob: "*_manager.rb"
        )
        @loaded_plugins = {}
        @loaded_managers = {}
      end

      ##
      # Starts the plugin process.
      def start
        puts_banner
        load_plugins
        start_managers
        @thread = Thread.new do
          sleep 10 until stopped
        end
      end

      ##
      # Joins the process thread.
      def join
        thread.join
      end

      ##
      # @return [Boolean] if the process is alive or dead
      def alive?
        thread.alive?
      end

      ##
      # Stops the plugin process
      def stop
        @stopped = true
        stop_managers
      end

      ##
      # Gets the specificed manager
      #
      # @return [Mjolnir::Manager::Base] the manager of the given name
      def get_manager(name)
        loaded_managers.fetch(name.to_s)
      end

      private

      attr_reader :loaded_plugins, :loaded_managers, :managers, :thread,
                  :stopped

      def puts_banner
        "Chimera MUD Engine - #{cannonical_name.to_s.capitalize} - " \
            "v#{Mjolnir::VERSION}"
      end

      def load_plugins
        logger.info "loading plugins..."
        Base.descendants.each do |descendant|
          logger.info "   loading #{descendant}"
          plugin = descendant.new
          plugin.load
          loaded_plugins[plugin.cannonical_name] = plugin
        end
      end

      def start_managers
        logger.info "starting managers..."
        managers.each do |name, file|
          logger.info "   starting #{name}"
          require(file)
          manager = name.classify.constantize.new(plugin: self)
          loaded_managers[name] = manager
          manager.start
        end
      end

      def stop_managers
        logger.info "stopping managers..."
        loaded_managers.each do |name, manager|
          logger.info "  stopping #{name}"
          manager.stop
        end
      end
    end
  end
end
