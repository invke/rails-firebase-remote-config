# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "firebase_remote_config/version"

Gem::Specification.new do |s|
  s.name        = "rails-firebase-remote-config"
  s.version     = FirebaseRemoteConfig::VERSION
  s.summary     = "Firebase Remote Config for Ruby on Rails"
  s.description = "Firebase Remote Config for Ruby on Rails"
  s.authors     = ["Montgomery Anderson"]
  s.email       = "montgomery.c.anderson@gmail.com"
  s.files       = ["lib/firebase_remote_config"]
end