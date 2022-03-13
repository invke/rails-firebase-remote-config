# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

gem "config"
gem "rails"

group :test do
  gem "rspec-rails"
  gem "sqlite3"
end

group :test, :development do
  gem "pry"
end

group :development do
  gem "paperkite-rubocop", tag: "v1.0.0-beta.6"
end
