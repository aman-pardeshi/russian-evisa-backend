module V1::User::Operation
  class ForgotPassword < Trailblazer::Operation
  
    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'email')

    step :validate_email
    fail :invalid_email, fail_fast: true

    step :send_reset_password_link
    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:email].present?
    end

    def validate_email(ctx, params:, **)
      (params[:email]=~EMAIL_REG) && User.find_by_email(params[:email])
    end

    def invalid_email(ctx, params:, **)
      ctx[:error] = I18n.t('errors.invalid', params:'email')
    end

    def send_reset_password_link(ctx, params:, **)
      user = User.find_by(email: params[:email])
      user.send_reset_password_instructions
    end
  end
end