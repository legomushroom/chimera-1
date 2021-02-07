# frozen_string_literal: true

module ChimeraMud
  class Plugin
    include Logging::Direct
    class << self
      attr_accessor :root

      extend ActiveSupport::DescendantsTracker

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
             !File.exist?(File.join(p, "chimera_mud.gemspec"))
            return p
          end

          File.join(p, dir)
        end
      end

      def path_regexp(base)
        %r{(#{base.name.underscore}|config/chimera\.rb)}
      end

      def cannonical_name
        name.split("::")[-2].underscore.to_sym
      end
    end

    attr_accessor :managers

    delegate :cannonical_name, to: :class

    def initialize
      @managers = PathResolver.new(self, "managers", "*_manager.rb")
    end
  end
end
