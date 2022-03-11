# frozen_string_literal: true

module RemoteConfig
  # Base class for all RemoteConfig models
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
