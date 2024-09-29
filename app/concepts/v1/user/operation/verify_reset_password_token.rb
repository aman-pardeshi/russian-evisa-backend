module V1::User::Operation
  class VerifyResetPasswordToken < Trailblazer::Operation
  
    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "reset_password_token")

    step :verify_token
    fail :invalid_token

    def check_params(ctx, params:, **)
      params[:reset_password_token].present?
    end

    def verify_token(ctx, params:, **)
      reset_password_token = Devise.token_generator.digest(User, :reset_password_token, params[:reset_password_token])
      User.find_by(reset_password_token: reset_password_token)
    end

    def invalid_token(ctx, params:, **)
      ctx[:error] = I18n.t('errors.reset_password_instruction')
    end
  end
end