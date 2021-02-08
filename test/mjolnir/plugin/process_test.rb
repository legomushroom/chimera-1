# frozen_string_literal: true

require "test_helper"

require_relative "../../dummy/lib/dummy/test_process"

module Mjolnir
  module Plugin
    class ProcessTest < ActiveSupport::TestCase
      def test_start_loads_plugins
        loaded_mock = Minitest::Mock.new
        loaded_mock.expect(:call, nil)

        # loaded is called by Dummy::Plugin::on_load
        Dummy::Plugin.stub(:loaded, loaded_mock) do
          process = Dummy::TestProcess.new
          process.start
          sleep 0.1 until process.alive?
          process.stop
        end

        loaded_mock.verify
      end

      def test_start_loads_managers
        process = Dummy::TestProcess.new
        process.start

        # test manager is defined in dummy/app/managers, and autoloaded on
        # plugin start
        manager = process.get_manager(:test_manager)
        sleep 0.1 until manager.alive?
        assert_instance_of TestManager, manager
        assert manager.alive?
        process.stop
      end
    end
  end
end
