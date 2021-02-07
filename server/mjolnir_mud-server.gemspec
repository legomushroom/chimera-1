# frozen_string_literal: true

version = File.read(File.expand_path("../MJOLNIR_VERSION", __dir__)).strip
Gem::Specification.new do |spec|
  spec.name        = "mjolnir_mud-server"
  spec.version     = version
  spec.authors     = ["Jarod Reid"]
  spec.email       = ["jarod@solidalchemy.com"]
  spec.homepage    = "https://github.com/mjolnir-mud/mjolnir/server"
  spec.summary     = "Chimera MUD Engine TCP Server"
  spec.description = "Chimera MUD Engine TCP Server"
  spec.license     = "MIT"

  spec.add_dependency "mjolnir_mud-core", version
  spec.add_dependency "rails", "~> 6.1.1"
end
