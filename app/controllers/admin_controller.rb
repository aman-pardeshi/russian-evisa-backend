class AdminController < BaseController
  before_action :authenticate!

  def submitted_applications
    run V1::AdminPortal::Operation::SubmittedApplications do |result|
      return cache_render V1::AdminApplicationSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def applied_applications
    run V1::AdminPortal::Operation::AppliedApplications do |result|
      return cache_render V1::AdminApplicationSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def all_applications
    run V1::AdminPortal::Operation::AllAdminApplications do |result| 
      return cache_render V1::AdminApplicationSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def apply_visa
    run V1::AdminPortal::Operation::ApplyVisa do |result| 
      return cache_render V1::AdminApplicationSerializer, result[:application], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 

  end

  def approve_visa
    run V1::AdminPortal::Operation::ApproveVisa do |result| 
      return cache_render V1::AdminApplicationSerializer, result[:application], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 

  end

  def reject_visa
    run V1::AdminPortal::Operation::RejectVisa do |result| 
      return cache_render V1::AdminApplicationSerializer, result[:application], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 

  end
end
