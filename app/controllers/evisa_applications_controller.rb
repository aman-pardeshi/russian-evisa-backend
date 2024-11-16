class EvisaApplicationsController < BaseController
  before_action :authenticate!

  def create
    run V1::EvisaApplication::Operation::Create do |result| 
      return render json: {
        reference_id: result[:reference_id]
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def delete
    run V1::EvisaApplication::Operation::Delete do |result| 
      return render json: {
        message: "Application Deleted Successfully!"
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def get_all_applications
    run V1::EvisaApplication::Operation::AllApplications do |result| 
      return render json: {
        data: result[:applications],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def get_all_submitted_applications
    run V1::EvisaApplication::Operation::AllSubmittedApplications do |result| 
      return render json: {
        data: result[:applications],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_applicant_details
    run V1::EvisaApplication::Operation::UpdateApplicantDetails do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_passport_details
    run V1::EvisaApplication::Operation::UpdatePassportDetails do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def upload_documents
    run V1::EvisaApplication::Operation::UploadDocument do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_employement_details
    run V1::EvisaApplication::Operation::UpdateEmploymentDetails do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_relatives_details
    run V1::EvisaApplication::Operation::UpdateRelativesDetails do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_additional_details
    run V1::EvisaApplication::Operation::UpdateAdditionalDetails do |result| 
      return render json: {
        data: result[:application],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def get_application_details
    run V1::EvisaApplication::Operation::ApplicationDetails do |result| 
      return render json: {
        data: V1::ApplicationSerializer.new(result[:application]).as_json,
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def all_admin_applications
    run V1::EvisaApplication::Operation::AllAdminApplications do |result| 
      return render json: {
        data: result[:applications],
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def update_status
    run V1::EvisaApplication::Operation::UpdateStatus do |result| 
      return render json: {
        data: V1::ApplicationSerializer.new(result[:application]).as_json,
        status: 200 
      }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def track_status
    run V1::EvisaApplication::Operation::TrackStatus do |result|
      return cache_render V1::TrackStatusSerializer, result[:application], status: 200
    end

    render json: {
      message: result[:error], status: ERROR_STATUS_CODE
    }
  end
end
