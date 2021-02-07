# frozen_string_literal: true

module Mjolnir
  module Core
    class RactorManager < Manager
      include Ractor::Common

      def initialize(**args)
        super(**args)
        @inbox = create_pipe
      end

      def <<(message)
        inbox.send(message, move: true)
      end

      def resume
        ensure_ractor
      end

      private

      def ensure_ractor
        @ractor ||= create_logging_ractor(self, inbox) do |_logger, manager, pipe|
          loop do
            message = pipe.take

            manager.next(message)
          end
        end
      end
    end
  end
end
