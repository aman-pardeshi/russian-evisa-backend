class AdminController < BaseController
  before_action :authenticate!

  def all_applications
    run V1::Admin::Operation::AllAdminApplications do |result| 
      return render json: {
        data: result[:applications],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end
end