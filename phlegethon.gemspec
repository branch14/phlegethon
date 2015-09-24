# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phlegethon/version'

Gem::Specification.new do |spec|
  spec.name          = "phlegethon"
  spec.version       = Phlegethon::VERSION
  spec.authors       = ["Phil Hofmann"]
  spec.email         = ["phil@branch14.org"]
  spec.description   = %q{Bridging PayPal Webhooks to RabbitMQ}
  spec.summary       = %q{Bridging PayPal Webhooks to RabbitMQ}
  spec.homepage      = "http://github.com/branch14/phlegethon"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'bunny'
  spec.add_dependency 'thin'
end
