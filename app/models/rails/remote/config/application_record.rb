# frozen_string_literal: true

module RemoteConfig
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
