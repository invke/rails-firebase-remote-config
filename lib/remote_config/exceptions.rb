# frozen_string_literal: true

module RemoteConfig
  class FlagError < StandardError
    attr_reader :key

    def initialize(key)
      @key = key
    end
  end

  class UnknownFeatureFlagError < FlagError
    def message
      "Unknown feature flag: #{key}"
    end
  end

  class NonBooleanFeatureFlagError < FlagError
    def message
      "Non-boolean feature flag: #{key}"
    end
  end
end
