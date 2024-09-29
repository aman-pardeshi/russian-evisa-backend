module V1::User::Operation
  class RunCampaignOnYourBehalf < Trailblazer::Operation
    
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :send_mail
    fail V1::Api::Macro.SomethingWentWrong

    def send_mail(ctx, current_user:, **)
      UserMailer.send_run_campaign_on_your_behalf(current_user).deliver!
    end
  end
end
