# frozen_string_literal: true

require "chimera/logging/formatter"

module ChimeraMud
  module Logging
    ##
    # Adds logging capabilities to whatever class this module is incuded. The
    # log file and level are automatically determined by the configuration of
    # the game
    module Direct
      extend ActiveSupport::Concern

      # :nodoc:
      module ClassMethods
        ##
        # Sets the tag that the logger for this class will use
        #
        # @param tag [String] the tag to use for the log
        #
        # @return [String] the tag set for this class
        def log_tag(tag = nil)
          @log_tag = tag if tag
          @log_tag
        end

        ##
        # @return [TaggedLogger] the log instance for the class. Note: the log
        # instance for the class will be different than the log instance for
        # the instance of the class
        def logger
          @logger ||= TaggedLogger.new(log_tag)
        end
      end
    end
  end
end
