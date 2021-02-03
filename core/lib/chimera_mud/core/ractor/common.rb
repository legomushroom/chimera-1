# frozen_string_literal: true

module Chimera
  module Core
    module Ractor
      ##
      # Common Ractor functionality
      module Common
        extend ActiveSupport::Concern

        def create_pipe
          ::Ractor.new do
            loop do
              ::Ractor.yield(::Ractor.receive, move: true)
            end
          end
        end

        def create_logging_ractor(*args, &block)
          ::Ractor.new(logger, *args, &block)
        end
      end
    end
  end
end
