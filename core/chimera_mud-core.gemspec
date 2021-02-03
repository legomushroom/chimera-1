# frozen_string_literal: true

require_relative "lib/chimera_mud/core/version"

Gem::Specification.new do |spec|
  spec.name        = "chimera_mud-core"
  spec.version     = ChimeraMud::Core::VERSION
  spec.authors     = ["Jarod Reid"]
  spec.email       = ["jarod@solidalchemy.com"]
  spec.homepage    = "https://github.com/chimera-mud/chimera/core"
  spec.summary     = "Core shared libraries for the Chimera MUD Engine"
  spec.description = "Core shared libraries for the Chimera MUD Engine"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "nats-pure", "~> 0.6.2"
  spec.add_dependency "rails", "~> 6.1.1"
end
