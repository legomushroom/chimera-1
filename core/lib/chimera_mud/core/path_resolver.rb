# frozen_string_literal: true

module ChimeraMud
  module Core
    class PathResolver
      include Enumerable

      def initialize(plugin, app_dir, glob)
        @plugin = plugin
        @paths = Plugin.descendants.map do |p|
          p.root.join("app", app_dir)
        end
        @glob = glob
        @file_cache = {}
      end

      def each(&block)
        reset_file_cache if Rails.env.development?
        file_cache.each(&block)
      end

      private

      attr_reader :plugin, :paths, :glob, :file_cache

      def reset_file_cache
        @file_cache = {}
        paths.each do |path|
          Dir.glob(File.join(path, glob)).each do |file|
            file_cache[parse_name(path, file)] = file
          end
          Dir.glob(File.join(path, plugin.cannonical_name, glob)) do |file|
            file_cache[parse_name(path, file)] = file
          end
        end
      end

      def parse_name(path, file)
        file.gsub("#{path}/", "").gsub(File.extname(file), "")
      end
    end
  end
end
