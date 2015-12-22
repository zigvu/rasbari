# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'messaging/version'

Gem::Specification.new do |s|
  s.name          = "messaging"
  s.version       = Messaging::VERSION
  s.authors       = ["Zigvu Inc."]
  s.summary       = "Engine to communicate with RabbitMq."
  s.description   = "Engine to communicate with RabbitMq."

  s.files         = Dir["{lib}/**/*", "Rakefile", "README.rdoc"]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_dependency "bunny"

  s.add_development_dependency "bundler", "~> 1.8"
  s.add_development_dependency "rake", "~> 10.0"
end
