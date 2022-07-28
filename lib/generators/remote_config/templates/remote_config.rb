# frozen_string_literal: true

RemoteConfig.configure do |config|
  # Overwrite to change the adapter to fetch the flags from a different source.
  # Currently, the gem only comes with the RubyConfigAdapter.
  config.adapter = RemoteConfig::Adapters::RubyConfigAdapter

  # Options to be provided to the specific adapters initialization.
  config.adapter_options = {
    const_name:        "Settings",
    feature_flags_key: "feature_flags",
    release_flags_key: "release_flags"
  }

  # Defines the release stages that are used to check release flags for their
  # current environments release status.
  #
  # A release flag is true if the current environment is in the release stage
  # configured for the flag.
  # e.g.
  # - if you have a release stage uat: [:uat, :dev, :development]
  # - and release flag "coffee.pre_pay" is configured to "uat"
  # - then it will return true when the Rails.env is either uat, dev or development
  # - and it will return false on other environments, e.g. production, staging
  config.release_stages = {
    production:  %i[production development],
    development: %i[development]
  }
end
