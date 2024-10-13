module V1
  class IncompleteApplicationsReportSerializer < CacheCrispies::Base
    serialize :id, :reference_id, :submission_id,:first_name, :last_name, :passport_number, :country, :group_email

    def group_email
      model.user.email
    end
  end
end