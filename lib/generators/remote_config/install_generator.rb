# frozen_string_literal: true

module RemoteConfig
  module Generators
    # Adapter for fetching feature and release flags from a set up config using
    # the Config gem (see https://github.com/rubyconfig/config).
    class InstallGenerator < ::Rails::Generators::Base
      desc "Generates a custom Rails RemoteConfig initializer file."

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def self.source_root
        @_config_source_root ||= File.expand_path("templates", __dir__)
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName

      def copy_initializer
        template "remote_config.rb", "config/initializers/remote_config.rb"
      end
    end
  end
end
