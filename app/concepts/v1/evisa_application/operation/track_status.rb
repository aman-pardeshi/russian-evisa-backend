
# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class TrackStatus < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID or Date of birth'), fail_fast: true

    step :find_application

    def check_params(ctx, params:, **)
      params[:referenceId].present? && params[:dateOfBirth].present?
    end

    def find_application(ctx, params:, **)
      
      ctx[:application] = Application.where(submission_id: params[:referenceId], date_of_birth: params[:dateOfBirth])
    end
  end
end