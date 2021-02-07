# frozen_string_literal: true

# require "active_support/descendants_tracker"

module ChimeraMud
  module Core
    class Plugin
      include Logging
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
            if File.exist?(File.join(p, "Gemfile")) &&
               !File.exist?(File.join(p, "chimera_mud.gemspec"))
              return p
            end

            File.join(p, dir)
          end
        end

        def cannonical_name
          File.basename(name.underscore)
        end
      end

      attr_accessor :managers

      delegate :cannonical_name, to: :class

      def initialize
        @managers = PathResolver.new(self, "managers", "*_manager.rb")
      end
    end
  end
end
