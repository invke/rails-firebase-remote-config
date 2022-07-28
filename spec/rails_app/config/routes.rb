Rails.application.routes.draw do
  mount RemoteConfig::Engine => "/remote_config"
end
