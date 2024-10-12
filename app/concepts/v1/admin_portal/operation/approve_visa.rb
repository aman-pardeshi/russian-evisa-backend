# frozen_string_literal: true

module V1::AdminPortal::Operation
  class ApproveVisa < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'refrence id or approval document')

    step :check_for_duplicate_update
    fail :duplicate_status_update, fail_fast: true

    step :update

    def check_params(ctx, params:, **) 
      params[:referenceId].present? || params[:approvalDocument].present?
    end
    
    def check_for_duplicate_update(ctx, params:, **) 
      application = Application.find_by(reference_id: params[:referenceId]).status != 'approved'
    end

    def duplicate_status_update(ctx, **)
      ctx[:error] = "Evisa already approved"
    end

    def update(ctx, params:, current_user:, **)
      application = Application.find_by(reference_id: params[:referenceId])

      application.update({
        status: 'approved',
        approval_document: params[:approvalDocument],
        approved_at: DateTime.now,
        approved_by: current_user
      })
      application.log_visa_status_change('approved', current_user)
      
      ctx[:application] = application
    end
  end
end