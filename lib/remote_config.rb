# frozen_string_literal: true

require "remote_config/version"
require "remote_config/engine"
require "remote_config/flagging"
require "remote_config/exceptions"
require "remote_config/adapters/base"
require "remote_config/adapters/ruby_config_adapter"

# Root gem module containing config and adapter setup.
module RemoteConfig
  Configuration = Struct.new(
    # A string to constantize to get the adapter
    :adapter,
    # The options hash to be passed to the adapter at initialization
    :adapter_options,
    # An hash of release stages to an array of rails environments that will have
    # the it will release to.
    :release_stages,
    keyword_init: true
  )

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new(
        adapter:         Adapters::RubyConfigAdapter,
        adapter_options: {},

        release_stages:  {
          production:  %i[production development],
          development: %i[development]
        }
      )
    end

    def adapter
      @adapter ||= Configuration.adapter.constantize.new(Configuration.adapter_options)
    end
  end
end
