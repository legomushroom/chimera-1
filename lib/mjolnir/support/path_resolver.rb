# frozen_string_literal: true

module Mjolnir
  module Support
    ##
    # The PathResolver loops through all included plugins and builds a virtual
    # path set of file types baed on the passed in glob. In this way plugins
    # can automatically load files of a spcific type based on a standard
    # Rails-like directory structure pattern.
    #
    # The PathResolver uses the `app` directory of plugins and the game
    # directory for its root path. Plugins are looped through in the order they
    # are declared, and plugins that have a duplicate file name will replace
    # files of the same name from earlier plugins, allowing plugins to easily
    # extend each other.
    #
    # The file cache is reset on every request in `development` mode to allow
    # reloading without having to restart the application.
    class PathResolver
      include Enumerable

      ##
      # @param [Plugin] plugin the plugin the resolver is attached to
      # @param [String] app_dir the base directory within the application
      #                         directory for which to look for files
      # @param [String] glob the glob pattern for which to look for files
      def initialize(plugin:, app_dir:, glob:)
        @plugin = plugin
        @paths = Plugin.descendants.map do |p|
          p.root.join("app", app_dir)
        end
        @glob = glob
        reset_file_cache
      end

      def find(name)
        auto_reset_file_cache
        file_cache[name]
      end

      def each(&block)
        auto_reset_file_cache
        file_cache.each(&block)
      end

      private

      attr_reader :plugin, :paths, :glob, :file_cache

      def reset_file_cache
        @file_cache = {}
        paths.each do |path|
          cache_universal_files(path)
          cache_plugin_specific_files(path)
        end
      end

      def cache_universal_files(path)
        Dir.glob(File.join(path, glob)).each do |file|
          file_cache[parse_name(path, file)] = file
        end
      end

      def cache_plugin_specific_files(path)
        Dir.glob(
          File.join(path, plugin.cannonical_name.to_s, glob)
        ) do |file|
          file_cache[parse_name(path, file)] = file
        end
      end

      def auto_reset_file_cache
        reset_file_cache if Rails.env.development?
      end

      def parse_name(path, file)
        file.gsub("#{path}/", "").gsub(File.extname(file), "")
      end
    end
  end
end
