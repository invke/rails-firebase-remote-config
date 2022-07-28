# frozen_string_literal: true

module RemoteConfig
  class Engine < ::Rails::Engine
    isolate_namespace RemoteConfig
  end
end
