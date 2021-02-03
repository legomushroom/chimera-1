# frozen_string_literal: true

require "rails_helper"
require "chimera/nats"

RSpec.describe ChimeraMudNats::Common do
  subject do
    Class.new do
      include ChimeraMudNats::Common

      # rubocop:disable Lint/UselessMethodDefinition
      def ensure_nats_connection
        super
      end
      # rubocop:enable Lint/UselessMethodDefinition
    end.new
  end

  describe "#ensure_nats_connection" do
    it "calls Nats::ensure_connection" do
      expect(ChimeraMudNats).to receive(:ensure_connection)
        .with("localhost", "4222")
        .and_return(true)

      expect(subject.ensure_nats_connection).to eq(true)
    end
  end
end
