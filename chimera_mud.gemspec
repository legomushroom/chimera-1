# frozen_string_literal: true

version = File.read(File.expand_path("./CHIMERA_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name = "chimera_mud"
  spec.required_ruby_version = "~> 3.0"
  spec.version     = version
  spec.authors     = ["Jarod Reid"]
  spec.email       = ["jarod@solidalchemy.com"]
  spec.homepage    = "https://github.com/chimera-mud/chimera"
  spec.summary     = "Chimera MUD Engine"
  spec.description = "Chimera MUD Engine"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "chimera_mud-core", version
  spec.add_dependency "chimera_mud-server", version
  spec.add_dependency "rails", "~> 6.1"
end
