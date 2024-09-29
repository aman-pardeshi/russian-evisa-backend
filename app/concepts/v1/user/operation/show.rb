# frozen_string_literal: true

module V1::User::Operation
  class Show < Trailblazer::Operation
    # step V1::Api::Macro.CheckAuthorizedUser
    # fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "id")

    step V1::User::Macro.LoadUser
    fail V1::Api::Macro.RecordNotFound("user")

    def check_params(ctx, params:, **)
      params[:id].present?
    end
  end
end
