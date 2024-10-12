# frozen_string_literal: true

module V1::AdminPortal::Operation
  class ApplyVisa < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'refrence id')



    step :update

    def check_params(ctx, params:, **) 
      params[:referenceId].present?
    end

    def check_for_duplicate_update(ctx, params:, **) 
      application = Application.find_by(reference_id: params[:referenceId]).status != 'applied'
    end

    def duplicate_status_update(ctx, **)
      ctx[:error] = "Evisa already applied"
    end

    def update(ctx, params:, current_user:, **)
      application = Application.find_by(reference_id: params[:referenceId])

      application.update({
        status: 'applied',
        visa_applied_at: DateTime.now,
        visa_applied_by: current_user
      })
      application.log_visa_applied_by(current_user)
      ctx[:application] = application
    end
  end
end