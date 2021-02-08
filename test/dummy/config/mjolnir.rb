# frozen_string_literal: true

module Dummy
  class Plugin < Mjolnir::Plugin::Base
    on_load do
      loaded
    end

    def self.loaded; end
  end
end
