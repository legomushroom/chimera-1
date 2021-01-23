# frozen_string_literal: true

require "rails_helper"

require "chimera/server"

RSpec.describe Chimera::Server::Instance do
  before :all do
    @server = described_class.new(port: "3232")
    @server.start
    sleep 0.1 until @server.started
  end

  after :all do
    @server.stop
  end

  describe "#start" do
    it "accepts new connections" do
      expect { TCPSocket.open("localhost", 3232).close }.to_not raise_error
    end
  end
end
