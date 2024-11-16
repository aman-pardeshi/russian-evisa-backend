# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdateEmploymentDetails < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID')

    step :update
    fail -> (ctx, application:, **) { ctx[:error] = application.errors.full_messages }, fail_fast: true

    def check_params(ctx, params:, **)
      params[:referenceId].present?
    end

    def update(ctx, params:, **)
      application = Application.find_by(reference_id: params[:referenceId])

      employment_details_params = {
        currently_employed_or_studying: params[:currentlyEmployedOrStudying],
        employment_or_study_details: params[:employmentOrStudyDetails]
      }

      application.update(employment_details_params)
      ctx[:application] = application
    end
  end
end
