# frozen_string_literal: true

require "rails_helper"
require "chimera/nats"

RSpec.describe ChimeraMudNats do
  describe "#ensure_connection" do
    let(:client) { double(NATS::IO::Client) }

    before :each do
      allow(NATS::IO::Client).to receive(:new).and_return(client)
    end

    after :each do
      described_class.remove_instance_variable(:@connection)
    end

    it "creates a new connetion instance if not yet created" do
      allow(client).to receive(:connected?).and_return(false)
      expect(client).to receive(:connect)
        .with(servers: ["nats://127.0.0.1:4333"])

      described_class.ensure_connection("127.0.0.1", "4333")
    end

    it "does not try to reconnect if the client is already connected" do
      allow(client).to receive(:connected?).and_return(true)
      expect(client).to_not receive(:connect)

      described_class.ensure_connection("127.0.0.1", "2323")
    end
  end
end
