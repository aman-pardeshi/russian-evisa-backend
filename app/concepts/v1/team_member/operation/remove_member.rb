module V1::TeamMember::Operation
  class RemoveMember < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: "organizer_id")

    step :parse_params

    step :remove_member

    def check_params(ctx, params:, **)
      params[:organizer_id].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:updated_params] = params.permit(:organizer_id)
    end

    def remove_member(ctx, updated_params:, current_user:, **)
      EventMember.where('user_id = ? AND invited_by = ?', updated_params[:organizer_id], current_user.id).destroy_all
    end
  end
end
