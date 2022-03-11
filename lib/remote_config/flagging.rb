# frozen_string_literal: true

module RemoteConfig
  # Module to be included into the using application to allow for checking
  # for feature and release flags.
  module Flagging
    def feature_enabled?(key)
      enabled = RemoteConfig.adapter.fetch_feature_flag(key)
      raise RemoteConfig::UnknownFeatureFlagError, key if enabled.nil?
      raise RemoteConfig::NonBooleanFeatureFlagError, key unless enabled.in? [true, false]

      yield if block_given? && enabled

      enabled
    end

    # rubocop:disable Metrics/AbcSize
    def released?(key)
      release_stage = RemoteConfig.adapter.fetch_release_flag(key)
      raise RemoteConfig::UnknownReleaseFlagError, key if release_stage.nil?

      release_stages_envs = RemoteConfig.configuration.release_stages[release_stage.to_sym]
      raise RemoteConfig::UnknownReleaseStageError.new(key, release_stage) if release_stages_envs.nil?

      is_released = release_stages_envs.map(&:to_s).include? Rails.env

      yield if block_given? && is_released

      is_released
    end
    # rubocop:enable Metrics/AbcSize
  end
end
