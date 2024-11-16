# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdateRelativesDetails < Trailblazer::Operation
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

      relatives_details_params = {
        marital_status: params[:maritalStatus],
        partner_details: params[:partnerDetails],
        has_mother: params[:hasMother],
        mother_details: params[:motherDetails],
        has_father: params[:hasFather],
        father_details: params[:fatherDetails],
      }

      application.update(relatives_details_params)
      ctx[:application] = application
    end
  end
end
