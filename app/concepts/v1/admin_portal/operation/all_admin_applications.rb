# frozen_string_literal: true

module V1::AdminPortal::Operation
  class AllAdminApplications < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :get_applications

    def get_applications(ctx, params:, current_user:, **)
      applications = Application.all.order(id: :desc)

      case params[:searchBy]
        when 'date'
          if params[:fromDate].present? && params[:toDate].present?
            from_date = Date.strptime(params[:fromDate], '%d-%m-%Y')
            to_date = Date.strptime(params[:toDate], '%d-%m-%Y').end_of_day

            applications = applications.where(created_at: from_date..to_date)
          end
        when 'applicationId'
          applications = applications.where(submission_id: params[:applicationId])
        when 'firstName'
          applications = applications.where("lower(first_name) LIKE ?", "%#{params[:firstName].downcase}%")
        when 'lastName'
          applications = applications.where("lower(last_name) LIKE ?", "%#{params[:lastName].downcase}%")
        when 'passport'
          applications = applications.where(passport_number: params[:passport])
      end

      ctx[:applications] = applications
    end
  end
end