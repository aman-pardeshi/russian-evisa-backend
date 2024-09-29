class V1::VerificationsController < V1::BaseController

  def create
    run V1::Verification::Operation::Create do|result|
     return render json: { data: V1::ReviewSerializer.new(result[:review]).as_json }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def update
    run V1::Verification::Operation::Update do|result|
      return render json: { data: V1::ReviewSerializer.new(result[:review]).as_json }
     end
 
     render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end
end
