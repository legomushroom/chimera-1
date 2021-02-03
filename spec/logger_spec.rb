# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChimeraMudLogging do
  subject do
    Class.new do
      include ChimeraMudLogging
    end.new
  end

  describe "#logger" do
    it "returns the rails logger" do
      expect(subject.logger).to be_a(Logger)
    end
  end
end
