module V1::User::Operation
  class ResetPassword < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'reset_password_token,password, password_confirmation')

    step :parse_params
    step :load_user
    fail V1::Api::Macro.RecordNotFound('user')

    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:reset_password_token].present? &&
      params[:password_confirmation].present? &&
      params[:password].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:password_params] = params.permit(:reset_password_token, :password_confirmation, :password)
    end

    def load_user(ctx, password_params:, **)
      User.reset_password_by_token(password_params)
    end
  end
end