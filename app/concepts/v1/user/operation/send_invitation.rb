module V1::User::Operation
  class SendInvitation < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :send_invitation
    fail :send_invitation_fail, fail_fast: true

    step :update_role
    fail V1::Api::Macro.SomethingWentWrong

    def send_invitation(ctx, params:, **)
      ctx[:result] = V1::User::Operation::Create.(params: params, source: 'invitation')
      ctx[:result].success?
    end

    def send_invitation_fail(ctx, result:, **)
      ctx[:error] = result[:error][0]
    end

    def update_role(ctx, params:, result:, **)
      result[:user].update!(role: params[:role])
      ctx[:message] = result[:message]
    end
  end
end
