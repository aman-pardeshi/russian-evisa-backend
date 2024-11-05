# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class Delete < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID'), fail_fast: true

    step :delete

    def check_params(ctx, params:, **)
      params[:referenceId].present? 
    end
    
    def delete(ctx, params:, current_user:, **)
      application = Application.where(reference_id: params[:referenceId]).last

      application.application_histories.destroy_all
      application.destroy
    end
  end
end