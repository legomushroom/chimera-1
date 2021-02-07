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
        @loaded_plugins = []
      end

      def start
        puts_banner
        load_plugins
      end

      private

      def puts_banner
        "Chimera MUD Engine - #{cannonical_name.to_s.capitalize} - " \
            "v#{Mjolnir::VERSION}"
      end

      def load_plugins
        Base.descendants.each do |descendant|

        end
      end
    end
  end
end
