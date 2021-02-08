# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

module Mjolnir
  module Plugin
    class BaseTest < ActiveSupport::TestCase
      attr_reader :dummy

      def setup
        @dummy = Dummy::Plugin.new
      end

      def test_cannonical_name
        assert_equal :dummy, Dummy::Plugin.cannonical_name
        assert_equal :dummy, dummy.cannonical_name
      end

      #       def test_has_manager_resolver
      #         assert_equal(
      #           Rails.root.join("app", "managers", "test_manager.rb").to_s,
      #           dummy.managers.find("test_manager")
      #         )
      #       end

      def test_tracks_descendents
        assert_instance_of Array, Base.descendants
        refute Base.descendants.include?(Process)
      end

      def test_has_logger
        assert_instance_of Logging::TaggedLogger, dummy.logger
      end

      def test_on_laod
        mock = Minitest::Mock.new

        plugin = Dummy::Plugin

        def plugin.loaded; end

        plugin.instance_eval do
          on_load do
            loaded
          end
        end

        mock.expect(:call, nil)
        plugin.stub(:loaded, mock) do
          plugin.new.load
        end

        mock.verify
      end
    end
  end
end
