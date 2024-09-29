module V1
  class TeamMembersController < V1::BaseController
    skip_before_action :authenticate!,
      only: [ :team_invite_response ]

    def index
      run V1::TeamMember::Operation::Index do|result|
        return render json: V1::TeamMemberSerializer.new(result[:member]).model
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def invite_team_member
      run V1::TeamMember::Operation::InviteTeamMember do|result|
        return render json: { message: I18n.t('success.action', action:'Team Invite Sent Sucessfully!') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def team_invite_response
      run V1::TeamMember::Operation::TeamInviteResponse do|result|
        return render json: { message: I18n.t('success.action', action:'Team Invite Accepted!') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end


    def remove_member
      run V1::TeamMember::Operation::RemoveMember do|result|
        return render json: { message: I18n.t('success.action', action:'Member removed')}
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end
  end
end
