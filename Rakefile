require "bundler/setup"

APP_RAKEFILE = File.expand_path("spec/rails_app/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"
require_relative "./lib/remote_config/version"

task :publish do
  if ENV["GITHUB_REF"] == "refs/tags/v#{RemoteConfig::VERSION}"
    puts "Release ref \"#{ENV["GITHUB_REF"]}\" matches gem version \"#{RemoteConfig::VERSION}\""
    exit 0
  else
    puts "Release ref \"#{ENV["GITHUB_REF"]}\" does not match gem version \"#{RemoteConfig::VERSION}\""
    exit 1
  end

  sh "gem build"
  sh "gem push remote_config-#{RemoteConfig::VERSION}"
  puts "Bult and pushed version #{RemoteConfig::VERSION} to rubygems"
end
