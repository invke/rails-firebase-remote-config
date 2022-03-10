# frozen_string_literal: true

module RemoteConfig
  module Adapters
    # Adapters are the interface for fetching the feature and release flags from
    # varying sources.
    class Base
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def fetch_feature_flag(key)
        raise NotImplementedError
      end

      def fetch_release_flag(key)
        raise NotImplementedError
      end
    end
  end
end
