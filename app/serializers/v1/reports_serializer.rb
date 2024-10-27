# frozen_string_literal: true

module V1
  class ReportsSerializer < CacheCrispies::Base
    serialize :id, :reference_id, :submission_id, :first_name, :last_name, :date_of_birth, :passport_number, :country, :visa_fee, :service_fee, :payment_reference_number, :visa_applied_at, :visa_applied_by, :status, :submitted_on, :approved_at, :approved_by, :rejected_at, :rejected_by
    
    def submitted_on
      model.submitted_on.present? ? model.submitted_on.strftime("%B %d, %Y") : ''
    end

    def visa_applied_at
      model.visa_applied_at.present? ? model.visa_applied_at.strftime("%B %d, %Y") : '' 
    end

    def approved_at
      model.approved_at.present? ? model.approved_at.strftime("%B %d, %Y") : ''
    end

    def rejected_at
      model.rejected_at.present? ? model.rejected_at.strftime("%B %d, %Y") : ''
    end

    def visa_applied_by
      model.visa_applied_by.as_json(only: [:id, :name, :role])
    end
  end
end