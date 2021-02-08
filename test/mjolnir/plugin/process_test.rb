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
          Dummy::TestProcess.new.start
        end

        loaded_mock.verify
      end
    end
  end
end
