# frozen_string_literal: true

module RemoteConfig
  module Adapters
    # Adapter for fetching feature and release flags from a set up config using
    # the Config gem (see https://github.com/rubyconfig/config).
    class RubyConfigAdapter
      def fetch_feature_flag(key); end

      def fetch_release_flag(key); end
    end
  end
end
