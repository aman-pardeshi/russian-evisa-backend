module V1::User::Operation
  class SendOtp < Trailblazer::Operation

    step :validate_params
    fail V1::Api::Macro.ParamsMissing(params: 'email')

    step :send_otp

    def validate_params(ctx, params:, **)
      params[:email].present?
    end

    def send_otp(ctx, params:, **)
      UserMailer.send_otp_for_new_user(params[:email], params[:otp]).deliver!
      return true
    end
  end
end