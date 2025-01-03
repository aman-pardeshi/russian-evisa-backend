# frozen_string_literal: true

module V1::Reports::Operation
  class AccountsReport < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :get_applications

    def get_applications(ctx, params:, current_user:, **)
      required_status = ['submitted', 'applied', 'approved', 'rejected']

      from_date = Date.strptime(params[:startDate], '%d-%m-%Y')
      to_date = Date.strptime(params[:endDate], '%d-%m-%Y').end_of_day
      
      ctx[:accounts] = User.where(role: 'applicant', created_at: from_date..to_date).order(id: :desc)

    end
  end
end