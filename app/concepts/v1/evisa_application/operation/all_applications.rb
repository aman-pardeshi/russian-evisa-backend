# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class AllApplications < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :get_applications

    def get_applications(ctx, current_user:, **)
      ctx[:applications] = Application.where(user_id: current_user.id, status: 'incomplete').order(id: :desc)
    end
  end
end