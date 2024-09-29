# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdateApplicantDetails < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID')

    step :update
    fail -> (ctx, application:, **) { ctx[:error] = application.errors.full_messages }, fail_fast: true

    def check_params(ctx, params:, **)
      params[:applicationId].present?
    end

    def update(ctx, params:, **)
      application = Application.find(params[:applicationId])

      personal_details_params = {
        first_name: params[:firstName],
        last_name: params[:lastName],
        date_of_birth: params[:dateOfBirth],
        place_of_birth: params[:placeOfBirth],
        gender: params[:gender],
        country: params[:country],
        email: params[:email],
        country_code: params[:countryCode],
        mobile: params[:mobile]
      }

      application.update(personal_details_params)
      ctx[:application] = application
    end
  end
end