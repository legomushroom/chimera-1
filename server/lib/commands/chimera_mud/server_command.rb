# frozen_string_literal: true

require "rails"
require "chimera_mud/core"
require "chimera_mud/server"

module ChimeraMud
  # :nodoc:
  class ServerCommand < Rails::Command::Base
    def start
      ChimeraMud::Core.start("Server")
    end
  end
end
