module V1::User::Operation
  class ValidateEmail < Trailblazer::Operation
    
    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'email')

    step :check_email_present_in_system
    fail :email_present

    def check_params(ctx, params:, **)
      params[:email].present?
    end

    def check_email_present_in_system(ctx, params:, **)
      ctx[:user] = User.find_by(email: params[:email])
      ctx[:user].blank?
    end

    def email_present(ctx, **)
      ctx[:error] = I18n.t('errors.email_already_present')
    end
  end
end