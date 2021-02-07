# frozen_string_literal: true

module Mjolnir
  module Plugin
    ##
    # Plugins are the core way to extend a Chimera Mud based game. The engine is
    # built such that all aspects are considered plugins, including the game
    # itself. Plugins have two core requirements:
    #
    #   1. that the plugin be wthin a [Rails Engine]() or:
    #   2. that a plugin be declared within a Rails application in
    #      `config/chimera.rb`
    class Base
      include Logging::Direct
      class << self
        attr_accessor :root

        extend ActiveSupport::DescendantsTracker

        def cannonical_name
          name.split("::")[-2].underscore.to_sym
        end

        def on_load; end

        def descendants
          super.select { |d| d != Process }
        end

        private

        def inherited(base)
          base.root = lambda do
            file = caller_locations
                   .map { |l| l.absolute_path || l.path }
                   .select { |f| path_regexp(base) =~ f }
                   .first
            Pathname.new(find_root(File.dirname(file)))
          end.call

          super(base)
        end

        def find_root(path)
          dirs = path.split("/")
          dirs.reduce("/") do |p, dir|
            if (File.exist?(File.join(p, "Gemfile")) ||
                File.exist?(File.join(p, "config.ru"))) &&
               !File.exist?(File.join(p, "mjolnir.gemspec"))
              return p
            end

            File.join(p, dir)
          end
        end

        def path_regexp(base)
          %r{(#{base.name.underscore}|config/mjolnir\.rb)}
        end
      end

      delegate :cannonical_name, to: :class
    end
  end
end
