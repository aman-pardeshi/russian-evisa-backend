class Application < ApplicationRecord
  after_create :generate_application_id
  belongs_to :user
  enum status: { incomplete: 0, submitted: 1, applied: 2, approved: 3, rejected: 4  }
  enum payment_status: { unpaid: 0, paid: 1 }
  mount_uploader :photo, PhotoUploader
  mount_uploader :passport_photo_front, PassportFrontUploader
  mount_uploader :passport_photo_back, PassportBackUploader

  def generate_application_id
    date_part = Time.now.strftime('%d%m%Y') 
    count_for_today = Application.where("DATE(created_at) = ?", Date.today).count + 1
    self.application_id = "RU/#{date_part}/#{count_for_today}"
    self.save
  end
end