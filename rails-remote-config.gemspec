# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remote_config/version"

Gem::Specification.new do |spec|
  spec.name        = "rails-remote-config"
  spec.version     = RemoteConfig::VERSION
  spec.summary     = "Remote Config for Ruby on Rails"
  spec.description = "Remote Config for Ruby on Rails"
  spec.authors     = ["Montgomery Anderson"]
  spec.email       = "montgomery.c.anderson@gmail.com"
  spec.homepage    = "https://github.com/paperkite/rails-remote-config"

  spec.required_ruby_version = 2.7

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
end
