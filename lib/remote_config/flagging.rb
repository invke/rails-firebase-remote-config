# frozen_string_literal: true

module RemoteConfig
  module Flagging
    def feature_enabled?(key)
      value = RemoteConfig.adapter.fetch_feature_flag(key)

      raise RemoteConfig::UnknownFeatureFlagError, key if value.nil?
      raise RemoteConfig::NonBooleanFeatureFlagError, key unless value.in? [true, false]

      value
    end

    def released?(key); end
  end
end
