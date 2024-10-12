# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdatePassportDetails < Trailblazer::Operation
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

      passport_details_params = {
        passport_number: params[:passportNumber],
        passport_place_of_issue: params[:passportPlaceOfIssue],
        passport_date_of_issue: params[:passportDateOfIssue],
        passport_expiry_date: params[:passportExpiryDate],
        intented_date_of_entry: params[:intentedDateOfEntry],
        is_other_nationality: params[:isOtherNationality],
        other_nationality: params[:otherNationality],
        year_of_acquistion: params[:yearOfAcquistion],
      }

      application.update(passport_details_params)
      ctx[:application] = application
    end
  end
end