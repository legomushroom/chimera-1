# frozen_string_literal: true

# require "active_support/descendants_tracker"

module ChimeraMud
  module Core
    class Plugin
      class << self
        attr_accessor :root

        extend ActiveSupport::DescendantsTracker

        def inherited(base)
          base.root = lambda do
            file = caller_locations
                   .map { |l| l.absolute_path || l.path }
                   .select { |f| /#{base.name.underscore}/ =~ f }
                   .first

            Pathname.new(find_root(File.dirname(file)))
          end.call

          super(base)
        end

        def find_root(path)
          dirs = path.split("/")
          dirs.reduce("/") do |p, dir|
            return p if File.exist?(File.join(p, "Gemfile")) &&
                        !File.exist?(File.join(p, "chimera_mud.gemspec"))

            File.join(p, dir)
          end
        end
      end

      def load_managers_for(plugin_namespace)
        plugin = plugin_namespace.const_get(:Plugin)
        puts plugin.root
        []
      end
    end
  end
end
