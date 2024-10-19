# frozen_string_literal: true

module V1::AdminPortal::Operation
  class RejectVisa < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'refrence id')

    step :check_for_duplicate_update
    fail :duplicate_status_update, fail_fast: true

    step :update

    def check_params(ctx, params:, **) 
      params[:referenceId].present?
    end

    def check_for_duplicate_update(ctx, params:, **) 
      application = Application.find_by(reference_id: params[:referenceId]).status != 'rejected'
    end

    def duplicate_status_update(ctx, **)
      ctx[:error] = "Evisa already rejected"
    end

    def update(ctx, params:, current_user:, **)
      application = Application.find_by(reference_id: params[:referenceId])

      application.update({
        status: 'rejected',
        rejection_note: params[:rejectionNote],
        rejected_at: DateTime.now,
        rejected_by: current_user
      })
      application.log_visa_status_change('rejected', current_user)
      
      UserMailer.application_rejection_email(application).deliver!

      ctx[:application] = application
    end
  end
end