module V1::User::Operation
  class SignIn <  Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'email,password')

    step :login_with_email
    fail :failed_to_login, fail_fast: true

    def check_params(ctx, params:, **)
      params[:email].present? &&  params[:password].present?
    end

    def login_with_email(ctx, params:, **)
      user = User.find_by(email: params[:email], status: 'active')
      ctx[:user] = user if user&.valid_password?(params[:password])
    end

    def failed_to_login(ctx, **)
      ctx[:error] =
        I18n.t('devise.failure.not_found_in_database', authentication_keys: 'email')
    end
  end
end
