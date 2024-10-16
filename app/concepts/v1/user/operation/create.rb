module V1::User::Operation
  class Create < Trailblazer::Operation

    step :validate_params
    fail V1::Api::Macro.ParamsMissing(params: 'email,name,password')

    step :parse_params
    step :validate_user
    fail :invalid_user, fail_fast: true

    step :create_user

    def validate_params(ctx, params:, **)
      params[:name].present? &&
      params[:email].present? &&
      params[:password].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:user_params] = {
        name: params[:name],
        email: params[:email],
        password: params[:password],
        role: 'applicant'
      }
    end

    def validate_user(ctx, user_params:, **)
      ctx[:user] = User.new(user_params)

      ctx[:user].skip_password_validation = true if ctx[:source].present?
      ctx[:user].valid?
    end

    def invalid_user(ctx, user:, **)
      ctx[:error] =  user.errors.full_messages.split(',')[0]
    end

    def create_user(ctx, user:, **)
      user.skip_confirmation!
      user.save!
    end
  end
end
