# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remote_config/version"

Gem::Specification.new do |s|
  s.name        = "rails-remote-config"
  s.version     = RemoteConfig::VERSION
  s.summary     = "Remote Config for Ruby on Rails"
  s.description = "Remote Config for Ruby on Rails"
  s.authors     = ["Montgomery Anderson"]
  s.email       = "montgomery.c.anderson@gmail.com"

  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
end