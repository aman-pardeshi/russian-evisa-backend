module V1::User::Operation
  class VerifyInvitationToken < Trailblazer::Operation
  
    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "invitation_token")

    step :verify_token
    fail :invalid_token

    def check_params(ctx, params:, **)
      params[:invitation_token].present?
    end

    def verify_token(ctx, params:, **)
      User.find_by_invitation_token(params[:invitation_token], true)
    end

    def invalid_token(ctx, params:, **)
      ctx[:error] = I18n.t('devise.invitations.invitation_token_invalid')
    end
  end
end