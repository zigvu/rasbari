$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "analysis/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "analysis"
  s.version     = Analysis::VERSION
  s.authors     = ["Zigvu Inc."]
  s.summary     = "Create and manage annotation operations."
  s.description = "Set-wise mining of video and frames."

  s.files = Dir["{app,bin,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
