# frozen_string_literal: true

require "chimera/version"

namespace :chimera do
  task server: :environment do
    require "chimera/server"
    puts "=> Booting Chimera MUD TCP Server #{Chimera::VERSION}"
    puts "=> Rails #{Rails::VERSION::STRING} starting in #{Rails.env}"
    host = ENV.fetch("CHIMERA_SERVER_HOST", "127.0.0.1")
    port = ENV.fetch("CHIMERA_SERVER_PORT", 2323)
    nats_host = ENV.fetch("CHIMERA_NATS_HOST", "localhost")
    nats_port = ENV.fetch("CHIMERA_NATS_PORT", "4222")

    puts "*  Environment: #{Rails.env}"
    puts "*          PID: #{Process.pid}"
    puts "* Listening on tcp://#{host}:#{port}"

    Rails.logger = Logger.new($stdout)

    Chimera::Server.run(
      host: host,
      port: port,
      nats_host: nats_host,
      nats_port: nats_port
    )
  end

  task world: :environment do
    require "chimera/game/world"
    puts "=> Booting Chimera MUD World"
    puts "=> Rails #{Rails::VERSION::STRING} starting in #{Rails.env}"

    puts "*  Environment: #{Rails.env}"
    puts "*          PID: #{Process.pid}"

    Rails.logger = Logger.new($stdout)

    Chimera::Game::World.start
  end
end
