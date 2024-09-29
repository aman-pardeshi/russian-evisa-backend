module V1::User::Operation
  class AcceptInvitation < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'invitation_token, password, password_confirmation')

    step :parse_params
    step :load_user
    fail V1::Api::Macro.RecordNotFound('user')

    step :update_password
    pass :accept_invitation
    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:invitation_token].present? &&
      params[:password].present? &&
      params[:password_confirmation].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:invitation_token] = params[:invitation_token]
      ctx[:password_params] = params.permit(:password_confirmation, :password)
    end

    def load_user(ctx, invitation_token:, **)
      ctx[:user] = User.find_by_invitation_token(invitation_token, true)
    end

    def update_password(ctx, user:, password_params:, **)
      user.update(password_params)
    end

    def accept_invitation(ctx, user:, password_params:, **)
      user.accept_invitation!
    end
  end
end