# frozen_string_literal: true

module V1
  class ApplicationSerializer < CacheCrispies::Base
    serialize :id, :reference_id, :submission_id, :first_name, :last_name, :date_of_birth, :place_of_birth, :gender, :country, :email, :country_code, :mobile, :passport_number, :passport_place_of_issue, :passport_date_of_issue, :passport_expiry_date, :intented_date_of_entry, :is_other_nationality, :other_nationality, :year_of_acquistion, :photo, :passport_photo_front, :passport_photo_back, :visa_fee, :service_fee, :status, :payment_status, :created_at, :updated_at, :group_email, :trip_purpose, :return_date

    def group_email
      model.user.email
    end
  end
end