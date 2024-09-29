module V1::User::Operation
  class UpdatePassword < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params:"old_password, password, password_confirmation")
    
    pass :parse_params

    step :check_is_password_set_or_not, Output(:failure) => Id(:update_password)

    step :check_old_password
    fail :invalid_old_password, fail_fast: true

    step :update_password
    fail :update_password_fail

    def check_params(ctx, params:, **)
      (params[:old_password].present? || !params[:is_password_set].nil?) &&
      params[:password].present? &&
      params[:password_confirmation].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:password_params] = params.permit(:password_confirmation,:password)
      ctx[:old_password] = params[:old_password] if params[:old_password].present?
    end

    def check_is_password_set_or_not(ctx, params:, **)
      params[:is_password_set].presence || true
    end

    def check_old_password(ctx, current_user:, **)
      current_user.valid_password?(ctx[:old_password])
    end

    def invalid_old_password(ctx, params:, **)
      ctx[:error] = I18n.t('errors.invalid_old_password')
    end

    def update_password(ctx, password_params:, current_user:, **)
      begin
        current_user.update!(password_params)
      rescue 
        false
      end
    end

    def update_password_fail(ctx, current_user:, **)
      ctx[:error] = current_user.errors.full_messages[0]
    end
  end
end