class Application < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, approved: 1, rejected: 2, on_hold: 3 }
  enum payment_status: { unpaid: 0, paid: 1 }
  mount_uploader :photo, PhotoUploader
  mount_uploader :passport_photo_front, PassportFrontUploader
  mount_uploader :passport_photo_back, PassportBackUploader
end