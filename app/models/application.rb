class Application < ApplicationRecord
  before_create :generate_reference_id
  after_create :generate_application_id
  belongs_to :user
  enum status: { incomplete: 0, submitted: 1, applied: 2, approved: 3, rejected: 4  }
  enum payment_status: { unpaid: 0, paid: 1 }
  mount_uploader :photo, PhotoUploader
  mount_uploader :passport_photo_front, PassportFrontUploader
  mount_uploader :passport_photo_back, PassportBackUploader
  mount_uploader :approval_document, ApprovalDocumentUploader
  has_many :application_histories
  after_create :log_creation
  belongs_to :visa_applied_by, class_name: "User", foreign_key: "visa_applied_by_id", optional: true
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true
  belongs_to :rejected_by, class_name: "User", foreign_key: "rejected_by_id", optional: true

  def generate_reference_id
    self.reference_id = SecureRandom.uuid if reference_id.blank?
    self.visa_fee = 50
    self.service_fee = 10
  end

  def generate_application_id
    date_part = Time.now.strftime('%d%m%Y') 
    count_for_today = Application.where("DATE(created_at) = ?", Date.today).count + 1
    self.submission_id = "RU/#{date_part}/#{count_for_today}"
    self.save
  end

  def log_creation
    ApplicationHistory.create!(
      application: self,
      user: self.user,
      description: "Application created",
    )
  end

  def log_submission
    ApplicationHistory.create!(
      application: self,
      user: self.user,
      description: "Application submitted",
    )
  end

  def log_visa_applied_by(user)
    ApplicationHistory.create!(
      application: self,
      user: user,
      description: "Visa Applied",
    )
  end

  def log_visa_status_change(status, user)
    ApplicationHistory.create!(
      application: self,
      user: user,
      description: "Visa #{status}",
    )
  end
end

# ["incomplete", "submitted", "applied", "approved", "rejected"]