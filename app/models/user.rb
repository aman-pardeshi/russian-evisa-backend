class User < ApplicationRecord
  audited on: [:update, :destroy]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  enum role: { admin: 1, applicant: 2 }
  has_one :linkedin_account, dependent: :destroy
  has_one :google_account, dependent: :destroy
  has_many :login_accounts, dependent: :destroy
  has_many :applications
  enum status: { active:0, inactive: 1 }
  scope :except_self, -> (user) { where.not(:id => user.id)}
  attr_accessor :skip_password_validation, :source
  mount_uploader :profile, BaseUploader
  after_update :send_deactivate_mail, if: :saved_change_to_status?


  def first_name
    name.split(" ")[0].presence || self.email
  end

  def last_name
    name.split(" ")[1].presence || self.email
  end

  def get_profile_url
    if self.login_accounts.present?
      if self.linkedin_account&.auth_hash.present?
        self.linkedin_account&.auth_hash["profile"]
      elsif self.google_account&.auth_hash.present?
        self.google_account&.auth_hash["profile"]
      end
    end
  end

  private

  def password_required?
    return false if skip_password_validation
    super
  end

  def send_deactivate_mail
    return unless self.inactive?
    UserMailer.deactivate_account(self).deliver!
  end
end
