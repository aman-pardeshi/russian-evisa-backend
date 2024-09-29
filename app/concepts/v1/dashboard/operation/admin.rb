module V1::Dashboard::Operation
  class Admin < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :create_date_range

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def create_date_range(ctx, params:, **)
      if params[:date_frame].present?
        start_date, end_date = params[:date_frame].split(",")
        ctx[:events] =
          Event
          .where(status: 'approved')
          .where(
            Event
            .arel_table[:start_date]
            .between(start_date..end_date)
          )
        ctx[:reviews] =
          ctx[:events].present? ? Review.where(event_id: ctx[:events].map(&:id)) : []
        ctx[:content_marketing_requests] =
          ContentMarketing.
          where(
            ContentMarketing
            .arel_table[:created_at]
            .between(start_date..end_date)
          )
        ctx[:campaign_builder_requests] =
          CampaignBuilder.
          where(
            CampaignBuilder
            .arel_table[:created_at]
            .between(start_date..end_date)
          )
        ctx[:organizers] =
          User
          .where(User.arel_table[:created_at].between(start_date..end_date))
          .organizer
          .active
          .count
      else
        ctx[:events] = Event.all
        ctx[:reviews] = Review.all
        ctx[:content_marketing_requests] = ContentMarketing.all
        ctx[:campaign_builder_requests] = CampaignBuilder.all
        ctx[:organizers] = User.organizer.active.count
      end
      ctx[:live_events] =
        Event
        .approved
        .where(Event.arel_table[:start_date].lteq(DateTime.now))
        .where(Event.arel_table[:end_date].gt(DateTime.now))
        .count
      ctx[:upcoming_events] =
        Event
        .where(Event.arel_table[:start_date].gt(DateTime.now))
        .count
    end

    def load_records(ctx, events:, reviews:, content_marketing_requests:, campaign_builder_requests:, organizers:, live_events:, upcoming_events:, **)
      records = {
        total_reviews: reviews.count,
        total_events: events.count,
        total_number_of_organizers: organizers,
        pending_events: events.pending.count,
        content_marketing_requests: content_marketing_requests.count,
        campaign_marketing_requests: campaign_builder_requests.count,
        complete_reviews: reviews.present? ? reviews.approved.count : reviews.count,
        time_spent_per_event: reviews.present? ? ("%.1f"% reviews.average('submission_time').to_f) : 0,
        pending_reviews: reviews.present? ? reviews.pending.count : reviews.count,
        flagged_reviews: reviews.present? ? reviews.where(is_flaged: true).count : reviews.count,
        decline_reviews: reviews.present? ? reviews.rejected.count : reviews.count,
        hold_reviews: reviews.present? ? reviews.on_hold.count : reviews.count,
        average_review_per_event: average_review_per_event(reviews),
        total_incentives: reviews.present? ? reviews.approved.joins(:campaign_link).sum("CAST(campaign_links.reward_amount AS INTEGER)") : 0,
        live_events: live_events,
        upcoming_events: upcoming_events
      }
      ctx[:records] =
        records.each do |key, value|
          records[key] =
          ActiveSupport::NumberHelper.number_to_delimited(value)
        end
      result =
        reviews.present? ? V1::Dashboard::Operation::CalculateFlagedReasonsPercentage.
        (reviews: reviews) : nil
      ctx[:records][:flag_reviews] = result.present? ? result[:records] : 0
    end

    private

    def average_review_per_event(reviews)
      begin
        event_count = reviews.pluck(:event_id).uniq.count
        review_count = reviews.count
        ans = (review_count == 0 || event_count == 0) ? 0.0 : (review_count.to_f / event_count.to_f)
        ("%.2f"% ans)
      rescue
        0.0
      end
    end
  end
end
