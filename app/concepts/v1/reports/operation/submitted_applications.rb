# frozen_string_literal: true

module V1::Reports::Operation
  class SubmittedApplications < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :get_applications

    def get_applications(ctx, current_user:, **)
      required_status = ['submitted', 'applied', 'approved', 'rejected']
      ctx[:applications] = Application.where(status: required_status).order(id: :desc)

    end
  end
end
