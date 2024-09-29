# frozen_string_literal: true

module V1::User::Operation
  class Index < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :load_users
    fail V1::Api::Macro.SomethingWentWrong

    def load_users(ctx, current_user:, params:, **)
      page = (params[:page].presence || '1').to_i
      limit = (params[:limit].presence || '100').to_i
      offset = (page - 1) * limit
      filter = params[:filter].present? ? params[:filter] : ""
      users =
        User
        .where.not(role: [1])
        .except_self(current_user)
        .includes(:login_accounts)
      ctx[:users] =
        if filter.present?
          if filter == 'pre_tagged'
            users.where(pre_tagged: true)
          elsif filter == 'pre_tagged_accepted'
            users.where(role: 'organizer')
          else
            User.where(team_member: true)
          end
        else
          ctx[:users]
        end
        
      ctx[:users] =
        if params[:query].present?
          ctx[:users]
            .joins("LEFT JOIN claim_requests ON claim_requests.claimed_by_id = users.id")
            .joins("LEFT JOIN events ON events.id = claim_requests.event_id")
            .where("events.title ILIKE :query AND claim_requests.status = :status", query: "%#{params[:query]}%", status: 1)
            .distinct
        else
          ctx[:users]
        end        
      ctx[:total_count] = ctx[:users].count
      ctx[:users] =
        ctx[:users].order(updated_at: :desc).offset(offset).limit(limit)
      ctx[:current_count] = ctx[:users].count
    end
  end
end
