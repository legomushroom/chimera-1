# frozen_string_literal: true

require "rails"
require "mjolnir/core"
require "mjolnir/server"

module Mjolnir
  # :nodoc:
  class ServerCommand < Rails::Command::Base
    def start
      Mjolnir.start(Mjolnir::Server::Plugin)
    end
  end
end
