# frozen_string_literal: true

module Mjolnir
  module Manager
    ##
    # Managers are the heart and soul of a Mjolnir powered game. They do
    # exactly as their name describes, and manage various aspects of the game.
    # There are two types of manager. `Base`, and `RactorBase` managers.
    #
    # The `Base` manager is the most typically used type of manager. It starts
    # a simple event loop calling Base#next on each iteration.
    #
    # Any plugin can declare a manager, but only `Process` plugins actually
    # start managers.
    class Base
      include Logging::Direct

      class << self
        ##
        # Gets or sets the manager name. If a value is provded the manager name
        # is sset to that value.
        #
        # @param [String] name the name the manager should be set to
        #
        # @return [String] the name of the manager
        def manager_name(name = nil)
          @manager_name = name if name

          @manager_name
        end
      end

      ##
      # @return [Plugin] the `Process` plugin that loaded the manager
      attr_reader :plugin

      delegate :manager_name, to: :class

      ##
      # @param [Plugin] plugin the `Process` plugin that is starting the
      #        managers.
      def initialize(plugin:)
        @plugin = plugin
      end

      ##
      # @return [Boolean] the status of the manager thread
      def alive?
        thread.alive?
      end

      ##
      # Starts the manager
      def start
        @thread = Thread.new do
          until stopped
            begin
              next
            rescue StandardError => e
              logger.error e
              raise e
            end
          end
        end
      end

      ##
      # Stops the manager
      def stop
        @stopped = true
      end

      private

      attr_reader :thread, :stopped

      def next(*)
        raise NotImplementedError
      end
    end
  end
end
