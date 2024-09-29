module V1::Dashboard::Operation
  class Organizer < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :create_date_range

    step :load_records
    fail V1::Api::Macro.SomethingWentWrong

    def create_date_range(ctx, params:, **)
      ctx[:date_range] =
        params[:date_frame].presence ||
        "#{DateTime.now.beginning_of_year},#{DateTime.now}"
    end

    def load_records(ctx, date_range:, current_user:, **)
      start_date, end_date = ctx[:date_range].split(",")
      events = current_user.events.where(Event.arel_table[:start_date].between(start_date..end_date))
      records = {
        total_events: events.where(status: "approved").count,
        total_reviews: events.where(status: "approved").joins(:reviews).count("reviews.id"),
        average_reviews_per_event: ("%.2f" % average_review_count(events)),
        flagged_reviews: events.joins(:reviews).where("reviews.is_flaged = true").count
      }
      ctx[:records] =
        records.each do |key, value|
          records[key] =
          ActiveSupport::NumberHelper.number_to_delimited(value)
        end
    end

    private

    def average_review_count events
      begin
        events.joins(:reviews).count("reviews.id")/
        Review.where(event_id: events.ids).pluck(:event_id).uniq.count
      rescue
        0
      end
    end
  end
end
