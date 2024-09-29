class Application < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, approved: 1, rejected: 2, on_hold: 3 }
  enum payment_status: { unpaid: 0, paid: 1 }
end