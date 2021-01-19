# frozen_string_literal: true

require "active_support/concern"

module Chimera
  ##
  # Common Ractor elements
  module RactorCommon
    extend ActiveSupport::Concern

    def create_pipe
      Ractor.new do
        loop do
          Ractor.yield(Ractor.receive, move: true)
        end
      end
    end

    def create_logging_ractor(*args, &block)
      Ractor.new(logger, *args, &block)
    end
  end
end
