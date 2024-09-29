# frozen_string_literal: true

module V1
  class GuestSerializer < CacheCrispies::Base
    serialize :name, :id, :email, :designation, :company_name
  end
end
