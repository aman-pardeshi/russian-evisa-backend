module V1::User::Operation
  class ContentMarketingRequest < Trailblazer::Operation
  
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :load_content_marketing_request
    fail V1::Api::Macro.SomethingWentWrong

    def load_content_marketing_request(ctx, current_user:, **)
      ctx[:content_marketing] = current_user.content_marketing_request || ContentMarketing.new
    end
  end
end
