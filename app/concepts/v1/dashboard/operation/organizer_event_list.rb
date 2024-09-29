module V1::Dashboard::Operation
  class OrganizerEventList < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :parse_params

    step :load_event
    fail V1::Api::Macro.SomethingWentWrong

    step :load_event_list

    step :load_reviews
    fail V1::Api::Macro.SomethingWentWrong

    def parse_params(ctx, params:,current_user:, **)
      ctx[:search_params] = params.permit(:id)
    end

    def load_event(ctx, search_params:, current_user:, **)
      ctx[:event_present] = search_params[:id].present?
      if ctx[:event_present]
        ctx[:event] = Event.find(search_params[:id])
      else
        approved_events_id = current_user.event_members.where(status: 'approved').map{|record| record.event_id}

        ctx[:event] = Event.where(id: approved_events_id, status: "approved").order(start_date: :asc).last
      end
    end

    def load_event_list(ctx, current_user:, **)
      approved_events_id = current_user.event_members.where(status: 'approved').map{|record| record.event_id}

      ctx[:event_list] = Event.where(id: approved_events_id, status: 'approved').order(start_date: :desc)
      ctx[:total_count] = ctx[:event_list].count
    end

    def load_reviews(ctx, event_present:, event:, **)
      review = event.reviews.where(status: 'approved').order(updated_at: :desc).limit(5)
      ctx[:review] =
        review.
        joins(event: [:country]).
        includes(
          :flaged_by, :saved_by, :campaign_link,
          :reviewer, :verification,
          review_submissions: [question: [:parent_question]],
          event: [:country])
    end
  end
end
