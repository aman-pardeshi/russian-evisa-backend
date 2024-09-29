module V1::User::Operation
  class BookmarkedEvents < Trailblazer::Operation

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def load_records(ctx, params:, current_user:, **)
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '100').to_i
      offset = (page - 1) * limit
      bookmarked_events_ids = current_user.user_insights.bookmarked_events.pluck(:resource_id)
      bookmarked_events = Event.where(id: bookmarked_events_ids).order(created_at: :desc)
      ctx[:total_count] = bookmarked_events.count
      ctx[:bookmarked_events] = bookmarked_events.offset(offset).limit(limit)
      ctx[:current_count] = ctx[:bookmarked_events].count
    end
  end
end
