module V1::User::Operation
  class ConfirmUser < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'confirmation_token')

    step :find_user_by_token
    fail :user_already_confirmed, fail_fast: true

    step :update_confirmation_at

    def check_params(ctx, params:, **)
      params[:confirmation_token].present?
    end

    def find_user_by_token(ctx, params:, **)
      ctx[:user] = User.find_by_confirmation_token(params[:confirmation_token])
    end

    def user_already_confirmed(ctx, **)
      ctx[:error] = I18n.t('errors.messages.already_confirmed')
    end

    def update_confirmation_at(ctx, user:, **)
      user.confirm
      user.update(confirmation_token: nil)
    end
  end
end
