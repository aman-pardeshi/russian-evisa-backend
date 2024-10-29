module V1::User::Operation
  class SignInWithGoogle < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'google_response[:accessToken], google_response[:profileObj]')

    step :parse_data_form_params
    step :find_or_create_user
    step :find_or_update_users_google_account
    fail :failed_to_login, fail_fast: true

    def check_params(ctx, params:, **)
      params[:google_response].present? &&
      # params[:google_response]["accessToken"].present? &&
      params[:google_response]["profileObj"].present?
    end

    def parse_data_form_params(ctx, params:, **)
      params = params[:google_response]
      ctx[:user_params] = {
        email: params["profileObj"]["email"],
        name: params["profileObj"]["name"],
        auth_hash: {
          profile: {
            url: params["profileObj"]["imageUrl"]
          },
          access_token: params["accessToken"],
          google_id: params["profileObj"]["googleId"]
        },
      }
    end

    def find_or_create_user(ctx, user_params:, **)
      user = User.find_or_initialize_by(email: user_params[:email])
      user.name = user_params[:name]
      user.role = 'applicant'
      user.skip_password_validation = true
      user.skip_confirmation_notification!
      ctx[:user] = user if user.save! && user.active?
    end

    def find_or_update_users_google_account(ctx, user:, user_params:, **)
      begin
        google_account = GoogleAccount.find_or_initialize_by(user_id: user.id)
        google_account.auth_hash = user_params[:auth_hash]
        google_account.save!
      rescue
        false
      end
    end

    def failed_to_login(ctx, **)
      ctx[:error] = I18n.t('errors.social_login_failed', account: 'Google')
    end
  end
end
