# frozen_string_literal: true

module V1::User::Operation
  class Delete < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "id")

    step V1::User::Macro.LoadUser
    fail V1::Api::Macro.RecordNotFound("user")

    step :delete
    fail :delete_fail, fail_fast: true

    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:id].present?
    end

    def delete(ctx, user:, **)
      user.destroy
    end

    def delete_fail(ctx, user:, **)
      ctx[:error] = user.errors.full_messages
    end
  end
end
