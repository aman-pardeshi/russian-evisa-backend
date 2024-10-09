# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class UploadDocument < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'Photo or Passport')

    step :update
    fail -> (ctx, application:, **) { ctx[:error] = application.errors.full_messages }, fail_fast: true


    def check_params(ctx, params:, **)
      params[:applicationId].present? || params[:photo].present? || params[:passport].present?
    end

    def update(ctx, params:, **)
      application = Application.find(params[:applicationId])

      file_params = {
        photo: params[:photo],
        passport_photo_front: params[:passportFront],
        passport_photo_back: params[:passportBack]
      }

      application.update(file_params)
      ctx[:application] = application
    end
  end
end