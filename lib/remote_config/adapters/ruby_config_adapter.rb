# frozen_string_literal: true

module RemoteConfig
  module Adapters
    # Adapter for fetching feature and release flags from a set up config using
    # the Config gem (see https://github.com/rubyconfig/config).
    class RubyConfigAdapter < Base
      def fetch_feature_flag(key)
        fetch_flag(options[:feature_flags_key], key)
      end

      def fetch_release_flag(key)
        fetch_flag(options[:release_flags_key], key)
      end

    private

      def fetch_flag(root_key, key)
        value = config_class.dig(root_key, *key.split("."))
        return value._ if value.is_a? Config::Options

        value
      rescue TypeError
        nil
      end

      def config_class
        options[:const_name].constantize
      end
    end
  end
end
