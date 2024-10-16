module V1
  class RegistrationsController < BaseController
    skip_before_action :authenticate!, only: [:create, :confirm]

    def create
      run V1::User::Operation::Create do|result|
        return  send_user_response result
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def confirm
      run V1::User::Operation::ConfirmUser do|result|
       return send_user_response result
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end
  end
end