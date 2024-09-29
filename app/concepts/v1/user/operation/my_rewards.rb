module V1::User::Operation
  class MyRewards < Trailblazer::Operation

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def load_records(ctx, params:, current_user:, **)
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '100').to_i
      offset = (page - 1) * limit
      my_rewards =
        current_user.
          reviews.
          approved.
          where.not(campaign_link: nil).
          includes(:event).
          order(created_at: :desc)
      ctx[:total_count] = my_rewards.count
      ctx[:my_rewards] = my_rewards.offset(offset).limit(limit)
      ctx[:current_count] = ctx[:my_rewards].count
    end
  end
end
