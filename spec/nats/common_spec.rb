# frozen_string_literal: true

require "rails_helper"
require "chimera/nats"

RSpec.describe Chimera::Nats::Common do
  subject do
    Class.new do
      include Chimera::Nats::Common
    end.new(nats_host: "localhost", nats_port: "4222")
  end

  describe "#ensure_nats_connection" do
    it "calls Nats::ensure_connection" do
      expect(Chimera::Nats).to receive(:ensure_connection).and_return(true)

      expect(subject.ensure_nats_connection).to eq(true)
    end
  end
end
