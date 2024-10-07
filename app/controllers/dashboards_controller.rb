class DashboardsController < BaseController
  before_action :authenticate!

  def admin
    run V1::Dashboard::Operation::Admin do|result|
      return render json: { data: result[:records] }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def organizer
    run V1::Dashboard::Operation::Organizer do|result|
      return render json: { data: result[:records] }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def organizer_events
    run V1::Dashboard::Operation::Events do|result|
      return cache_render V1::OrganizerDashboardEventSerializer, result[:events],
        meta: pagination_hash(result[:total_count], result[:current_count])
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def event_statistics
    run V1::Dashboard::Operation::EventStatistics do|result|
      return render json: { data: result[:records] }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

  def organizer_event_list
    run V1::Dashboard::Operation::OrganizerEventList do|result|
      return render json: {
        data: V1::OrganizerDashboardEventSerializer.new(result[:event]).as_json,
        event_list: result[:event_list],
        review_list: result[:review].map do|review| V1::ReviewSerializer.new(review).as_json end
       }
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE
  end

end
