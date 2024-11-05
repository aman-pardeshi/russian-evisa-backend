
# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class TrackStatus < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Application ID'), fail_fast: true

    step :find_application

    def check_params(ctx, params:, **)
      params[:referenceId].present? 
    end

    def find_application(ctx, params:, **)      
      ctx[:application] = Application.where(reference_id: params[:referenceId])
    end
  end
end