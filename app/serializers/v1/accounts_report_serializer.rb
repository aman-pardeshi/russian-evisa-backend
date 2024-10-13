# frozen_string_literal: true

module V1
  class AccountsReportSerializer < CacheCrispies::Base
    serialize :id, :email, :name, :created_at, :mobile_number, :submitted_applications, :incomplete_applications

    def submitted_applications
      model.applications.where.not(status: 'incomplete').count
    end

    def incomplete_applications
      model.applications.where(status: 'incomplete').count
    end

    def created_at
      model.created_at.present? ? model.created_at.strftime("%B %d, %Y") : ''
    end
  end
end