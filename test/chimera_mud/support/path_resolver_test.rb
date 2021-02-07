# frozen_string_literal: true

require "test_helper"

module ChimeraMud
  module Support
    class PathResolverTest < ActiveSupport::TestCase
      def test_resolver
        resolver = PathResolver.new(
          plugin: Dummy::Plugin,
          app_dir: "test",
          glob: "*_class.rb"
        )

        assert_equal(
          Rails.root.join("app", "test", "test_class.rb").to_s,
          resolver.find("test_class")
        )

        assert_equal(
          Rails.root.join("app", "test", "dummy", "test_sub_class.rb").to_s,
          resolver.find("dummy/test_sub_class")
        )
      end
    end
  end
end
