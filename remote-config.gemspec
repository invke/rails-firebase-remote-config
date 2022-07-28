# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remote_config/version"

Gem::Specification.new do |spec|
  spec.name        = "remote_config"
  spec.version     = RemoteConfig::VERSION
  spec.authors     = ["Montgomery Anderson"]
  spec.email       = "montgomery.c.anderson@gmail.com"

  spec.summary     = "Remote Config for Ruby on Rails"
  spec.description = "Remote Config for Ruby on Rails"
  spec.homepage    = "https://github.com/paperkite/rails-remote-config"

  spec.require_paths         = ["lib"]
  spec.required_ruby_version = ">= 2.5.0"

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  spec.add_dependency "config"
  spec.add_dependency "rails"

  spec.add_development_dependency "paperkite-rubocop", "1.0.0-beta.6"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
end
