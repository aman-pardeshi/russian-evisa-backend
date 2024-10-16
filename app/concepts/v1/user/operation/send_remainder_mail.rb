module V1::User::Operation
  class SendRemainderMail < Trailblazer::Operation
    
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'id')

    step V1::User::Macro.LoadUser
    fail V1::Api::Macro.RecordNotFound('user')

    step :send_remainder_mail
    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:id].present?
    end

    def send_remainder_mail(ctx, user:, **)
      UserMailer.send_vendor_request_approved_mail(user).deliver!
    end
  end
end
