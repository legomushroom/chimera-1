# frozen_string_literal: true

require "test_helper"

module Mjolnir
  module Manager
    class BaseTest < ActiveSupport::TestCase
      def test_can_be_named
        klass = Class.new(Base) do
          manager_name "test"
        end

        assert_equal "test", klass.manager_name
        assert_equal "test", klass.new(plugin: nil).manager_name
      end

      def test_has_plugin
        plug = Object.new
        manager = Class.new(Base).new(plugin: plug)

        assert_equal plug, manager.plugin
      end

      def test_can_start_stop_and_call_next
        mock_next = Minitest::Mock.new
        mock_next.expect :call, nil

        manager = Class.new(Base) do
          def next; end
        end.new(plugin: nil)

        manager.stub(:next, mock_next) do
          manager.start
          sleep 0.1 until manager.alive?
          manager.stop
          sleep 0.1 while manager.alive?
        end

        refute manager.alive?
      end
    end
  end
end
