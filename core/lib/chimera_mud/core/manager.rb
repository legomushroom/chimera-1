# frozen_string_literal: true

require "chimera_mud/core/nats"

module ChimeraMud
  module Core
    class Manager
      include Nats::Common
      include Logging

      attr_reader :plugin

      def initialize(plugin:, **_args)
        @plugin = plugin
      end

      def <<(message)
        inbox << message
      end

      def next(_)
        raise NotImplementedError
      end

      def resume
        fiber.resume(inbox.pop) if inbox.length.positive?
      end

      private

      def inbox
        @inbox ||= []
      end

      def fiber
        @fiber ||= Fiber.new do |value|
          loop do
            self.next(Fiber.yield(value))
          end
        end
      end
    end
  end
end
