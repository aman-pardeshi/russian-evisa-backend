# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdateStatus < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'refrence id')

    step :update

    def check_params(ctx, params:, **)
      params[:referenceId].present?
    end

    def update(ctx, params:, current_user:, **)
      application = Application.find_by(reference_id: params[:referenceId])

      application.update({
        status: 'submitted',
        payment_status: 'paid',
        payment_reference_number: 'PAYIEIJEHERWIh',
        submitted_on: DateTime.now
      })

      UserMailer.application_submitted_acknowledge(current_user).deliver!
      AdminMailer.notify_admin_new_application(current_user, application).deliver!
      application.log_submission
      ctx[:application] = application
    end
  end
end