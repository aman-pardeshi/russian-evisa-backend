# frozen_string_literal: true

module V1::User::Operation
  class Update < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "id")

    step V1::User::Macro.LoadUser
    fail V1::Api::Macro.RecordNotFound("user")

    step :parse_params
    step :update
    fail :update_fail
    pass :remove_images

    def check_params(ctx, params:, **)
      params[:id].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:update_params] = 
        params.permit(
          :email, :name, :company_name,:designation, :mobile_number, :status, :profile,
          :twitter_handle, :linkedin_url, :designation, :activate_notifications
        )
    end

    def update(ctx, update_params:, **)
      ctx[:user].update(update_params)
    end

    def remove_images(ctx, params:, user:, **)
      if params[:remove_profile].present?
        user.remove_profile!
        user.save!
      end
    end
  end
end
