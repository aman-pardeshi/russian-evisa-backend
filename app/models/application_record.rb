class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # default_scope { where(is_active: true) }
end
