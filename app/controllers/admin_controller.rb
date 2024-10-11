class AdminController < BaseController
  before_action :authenticate!

  def submitted_applications
    run V1::AdminPortal::Operation::SubmittedApplications do |result|
      return render json: {
        data: result[:applications],
        status: 200
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def applied_applications
    run V1::AdminPortal::Operation::AppliedApplications do |result|
      return render json: {
        data: result[:applications],
        status: 200
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def all_applications
    run V1::AdminPortal::Operation::AllAdminApplications do |result| 
      return render json: {
        data: result[:applications],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_status
  end
end
