class LoginAccount < ApplicationRecord
  audited on: [:update, :destroy]
  belongs_to :user
end
