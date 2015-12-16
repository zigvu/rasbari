$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sample_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sample_engine"
  s.version     = SampleEngine::VERSION
  s.authors     = ["Zigvu Inc."]
  s.summary     = "TODO: Summary of SampleEngine."
  s.description = "TODO: Description of SampleEngine."

  s.files = Dir["{app,bin,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "simple_form"
  s.add_dependency "draper", "~> 1.3"

  s.add_development_dependency "sqlite3"
end
