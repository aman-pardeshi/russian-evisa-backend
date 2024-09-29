module V1::User::Operation
  class Create < Trailblazer::Operation

    step :validate_params
    fail V1::Api::Macro.ParamsMissing(params: 'email,name,password')

    step :parse_params
    step :validate_user
    fail :invalid_user, fail_fast: true

    step -> (ctx, **) { ctx[:source].present? }, Output(:failure) => Id(:create_user)
    step :check_source_and_send_instructions
    step :create_user

    def validate_params(ctx, params:, **)
      if ctx[:source].present?
        params[:name].present? &&
        params[:email].present?
      else
        params[:name].present? &&
        params[:email].present? &&
        params[:password].present?
      end
    end

    def parse_params(ctx, params:, **)
      ctx[:user_params] =
        params.
        permit(:name, :email, :password, :password_confirmation,
          :company_name, :designation, :twitter_handle, :linkedin_url, :team_member, :role, :signup_source)
    end

    def validate_user(ctx, user_params:, **)
      ctx[:user] = User.new(user_params)
      ctx[:user].skip_password_validation = true if ctx[:source].present?
      ctx[:user].valid?
    end

    def invalid_user(ctx, user:, **)
      ctx[:error] =  user.errors.full_messages.split(',')[0]
    end

    def check_source_and_send_instructions(ctx, user:, **)
      user.skip_confirmation!
      case ctx[:source]
      when 'review'
        user.source = ctx[:source]
        user.send_reset_password_instructions
      when 'vendor_request'
        user.source = ctx[:source]
        user.send_reset_password_instructions
      when 'invitation'
        user.invite!
      end
    end

    def create_user(ctx, user:, **)
      user.save!
      ctx[:message] =
        if ctx[:source].blank?
          I18n.t('devise.confirmations.send_instructions')
        else
          I18n.t('devise.invitations.send_instructions', email: user.email)
        end
    end
  end
end
