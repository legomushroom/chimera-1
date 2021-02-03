# frozen_string_literal: true

module ChimeraMud
  # :nodoc:
  class ServerCommand < Rails::Command::Base
    def start
      require "chimera_mud/core"
      ChimeraMud::Core.start("Server")
    end
  end
end
