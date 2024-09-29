# frozen_string_literal: true

module V1
  class UserSerializer < CacheCrispies::Base
    serialize :id, :name, :email, :role, :designation, :profile,
      :last_sign_in_ip, :last_sign_in_at, :current_sign_in_ip, :current_sign_in_at, :sign_in_count,
      :status, :mobile_number, :company_name, :member_since, :is_password_set,
      :is_google_signing, :is_manual_signing

    def last_sign_in_at
      V1::DateTimeFormatter.format_date_time(model&.last_sign_in_at)
    end

    def current_sign_in_at
      V1::DateTimeFormatter.format_date_time(model&.current_sign_in_at)
    end

    def profile
      if model&.profile.present?
        model&.profile
      elsif model&.login_accounts.present?
        model&.login_accounts.last.auth_hash["profile"]
      end
    end

    def current_sign_in_ip
      model&.current_sign_in_ip.to_s
    end

    def last_sign_in_ip
      model&.last_sign_in_ip.to_s
    end

    def member_since
      V1::DateTimeFormatter.format_date(model.created_at)
    end

    def is_password_set
      model.encrypted_password.nil? ? false : true
    end

    def is_google_signing
      model.google_account.present?
    end

    def is_manual_signing
      model.encrypted_password.present?
    end
  end
end
