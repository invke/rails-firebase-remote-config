# frozen_string_literal: true

module RemoteConfig
  module Flagging
    def feature_enabled?(key)
      value = RemoteConfig.adapter.fetch_feature_flag(key)
      raise RemoteConfig::UnknownFeatureFlagError, key if value.nil?
      raise RemoteConfig::NonBooleanFeatureFlagError, key unless value.in? [true, false]

      value
    end

    def released?(key)
      value = RemoteConfig.adapter.fetch_release_flag(key)
      raise RemoteConfig::UnknownReleaseFlagError, key if value.nil?

      current_release_stage = RemoteConfig.configuration.release_stages[value.to_sym]
      raise RemoteConfig::UnknownReleaseStageError.new(key, value) if current_release_stage.nil?

      current_release_stage.map(&:to_s).include? Rails.env
    end
  end
end
