module V1::User::Operation
  class ReviewedEvents < Trailblazer::Operation

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def load_records(ctx, params:, current_user:, **)
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '100').to_i
      offset = (page - 1) * limit
      user_reviewed_event_ids = current_user.reviews.approved.order(created_at: :desc).pluck(:event_id).uniq
      reviewed_events = Event.where(id: user_reviewed_event_ids)
      ctx[:total_count] = reviewed_events.count
      ctx[:reviewed_events] = reviewed_events.offset(offset).limit(limit)
      ctx[:current_count] = ctx[:reviewed_events].count
    end
  end
end
