# frozen_string_literal: true

module V1::AdminPortal::Operation
  class SubmittedApplications < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :get_applications

    def get_applications(ctx, current_user:, **)
      ctx[:applications] = Application.where(status: 'submitted').order(id: :desc)
    end
  end
end
