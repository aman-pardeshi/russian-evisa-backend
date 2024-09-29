module V1::TeamMember::Operation
  class Index < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :load_team_members
    fail V1::Api::Macro.SomethingWentWrong

    def load_team_members(ctx, current_user:, params:, **)
    
      member = EventMember.find_by('user_id = ? AND invited_by = ?', current_user.id, current_user.id)
      if member.present?
        @user_id = member.invited_by
      else
        @user_id = EventMember.find_by(user_id: current_user.id)&.invited_by
      end

      user = User.where.not(id: current_user.id)
            .where(id: EventMember.where(invited_by: @user_id).pluck(:user_id).uniq)
            
      ctx[:member] = user.order(:id).all.map do |member|
        member_detail = EventMember.where("user_id = ? AND invited_by = ?", member.id, @user_id ).first
        {
            id: member.id,
            name: member.name,
            email: member.email,
            company_name: member.company_name,
            designation: member.designation,
            status: member_detail&.status,
            invited_at: member_detail&.created_at
        }
      end
    end
  end
end
