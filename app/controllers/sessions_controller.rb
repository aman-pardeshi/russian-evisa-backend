# frozen_string_literal: true

class SessionsController < BaseController
  skip_before_action :authenticate!

  def create
    run V1::User::Operation::SignIn do|result|
      return send_user_response result
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def linkedin
    run V1::User::Operation::SignInWithLinkedin do|result|
      return send_user_response result
    end

    render json: { message:  result[:error] }, status: ERROR_STATUS_CODE
  end

  def google
    run V1::User::Operation::SignInWithGoogle do|result|
      return send_user_response result
    end

    render json: { message:  result[:error] }, status: ERROR_STATUS_CODE
  end
end

