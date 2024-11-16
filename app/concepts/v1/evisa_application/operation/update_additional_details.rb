# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UpdateAdditionalDetails < Trailblazer::Operation
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

      additional_details_params = {
        home_address: params[:homeAddress],
        type_of_accommodation: params[:typeOfAccommodation],
        accommodation_details: params[:accommodationDetails],
        visited_countries_recently: params[:vistedCountriesRecently],
        visited_countries_details: params[:visitedCountriesDetails]
      }

      application.update(additional_details_params)
      ctx[:application] = application
    end
  end
end
