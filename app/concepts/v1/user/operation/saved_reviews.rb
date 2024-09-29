module V1::User::Operation
  class SavedReviews < Trailblazer::Operation

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def load_records(ctx, params:, current_user:, **)
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '100').to_i
      offset = (page - 1) * limit
      saved_reviews_id = current_user.user_insights.bookmarked_reviews.pluck(:resource_id)
      saved_reviews = Review.where(id: saved_reviews_id).order(created_at: :desc)
      ctx[:total_count] = saved_reviews.count
      ctx[:saved_reviews] = saved_reviews.offset(offset).limit(limit)
      ctx[:current_count] = ctx[:saved_reviews].count
    end
  end
end
