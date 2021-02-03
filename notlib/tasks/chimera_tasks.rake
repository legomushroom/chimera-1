# frozen_string_literal: true

require "chimera/version"

namespace :chimera do
  task game_environment: :environment do
    @nats_host = ENV.fetch("CHIMERA_NATS_HOST", "localhost")
    @nats_port = ENV.fetch("CHIMERA_NATS_PORT", "4222")
  end

  task server: :game_environment do
    require "chimera/server"
    puts "=> Booting Chimera MUD TCP Server #{ChimeraMudVERSION}"
    puts "=> Rails #{Rails::VERSION::STRING} starting in #{Rails.env}"
    host = ENV.fetch("CHIMERA_SERVER_HOST", "127.0.0.1")
    port = ENV.fetch("CHIMERA_SERVER_PORT", 2323)

    puts "*  Environment: #{Rails.env}"
    puts "*          PID: #{Process.pid}"
    puts "* Listening on tcp://#{host}:#{port}"

    Rails.logger = Logger.new($stdout)

    ChimeraMudServer::Instance.new(
      host: host,
      port: port,
      nats_host: @nats_host,
      nats_port: @nats_port
    ).run
  end

  task world: :game_environment do
    require "chimera/world"
    puts "=> Booting Chimera MUD World"
    puts "=> Rails #{Rails::VERSION::STRING} starting in #{Rails.env}"

    puts "*  Environment: #{Rails.env}"
    puts "*          PID: #{Process.pid}"

    Rails.logger = Logger.new($stdout)

    ChimeraMudWorld::Instance.new(
      nats_host: @nats_host,
      nats_port: @nats_port
    ).run
  end
end
