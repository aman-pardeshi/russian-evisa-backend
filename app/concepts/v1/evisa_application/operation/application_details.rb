# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class ApplicationDetails < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID')

    step :find_application
    fail :no_application_found

    def check_params(ctx, params:, **)
      params[:applicationId].present?
    end
    
    def find_application(ctx, params:, **) 
      application = Application.find_by(id: params[:applicationId])
      ctx[:application] = application 

      application.present?
    end

    def no_application_found(ctx, **)
      ctx[:error] = "Invalid Application ID"
       ctx[:status] = :not_found
    end
  end
end