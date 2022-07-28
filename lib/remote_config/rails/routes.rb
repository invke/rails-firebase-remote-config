# frozen_string_literal: true

module ActionDispatch
  module Routing
    # Re-open the ActionDispatch::Routing::Mapping class and include the methods
    # for flagging.
    class Mapper
      include RemoteConfig::Flagging
    end
  end
end
