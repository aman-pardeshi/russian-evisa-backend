module V1::Dashboard::Operation
  class Events < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :create_date_range

    step :load_events
    fail V1::Api::Macro.SomethingWentWrong

    def create_date_range(ctx, params:, **)
      ctx[:date_range] =
        params[:date_frame].presence ||
        "#{DateTime.now.beginning_of_year},#{DateTime.now}"
    end

    def load_events(ctx, current_user:, params:, **)
      start_date, end_date = ctx[:date_range].split(",")
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '10').to_i
      offset = (page - 1) * limit
      query = params[:query].presence || ''
      approved_events_id =
        current_user
        .event_members
        .where(status: 'approved').map{|record| record.event_id}  
      
      events = Event.where(id: approved_events_id).where(Event.arel_table[:start_date].between(start_date..end_date)).where('lower(title) like ?',"%#{query.downcase}%").order(eventible_score: :desc, end_date: :desc)
        
      ctx[:total_count] = events.count
      ctx[:events] = events.offset(offset).limit(limit)
      ctx[:current_count] = ctx[:events].count
    end
  end
end
