# frozen_string_literal: true

module ChimeraMud
  module Support
    class FileResolver
      def initialize(app_dir:, glob:, include_base: false)
        @app_dir = app_dir
        @glob = glob
        @include_base = include_base
        reset_cache
      end

      private

      attr_accessor :app_dir, :glob, :include_base

      def reset_cache
        @file_cache = Concurrent::Map.new
      end
    end
  end
end
