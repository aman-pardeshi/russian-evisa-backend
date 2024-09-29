module V1::TeamMember::Operation
  class TeamInviteResponse < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'token')

    # step :load_user
    # fail V1::Api::Macro.SomethingWentWrong

    step :update_invite_status

    def check_params(ctx, params:,**)
      params[:token].present?
    end

    # def load_user(ctx, params, **)
    #   ctx[:team_invite] = EventMember.where(invite_team_token: params[:token])
    # end

    def update_invite_status(ctx, params:, **)
      if params[:password].present?
        user = User.find_by(email: params[:email])

        user_registered_through_trigger = params[:triggerId].present? ?  EmailTracker.find(params[:triggerId]).mail_trigger : ""

        #Only updating the role for speaker who came from normal triggers
        if user_registered_through_trigger != "Speaker Invite Trigger"
          user.update(role: 'organizer')
        end

        #to claim organizer
        vendor_request_attributes = {
          name: user.name,
          email: user.email,
          user_id: user.id,
          company_name: user.company_name,
          designation: user.designation,
          is_event_listed: true,
          status: 'approved'
        }
        

        if user_registered_through_trigger != "Speaker Invite Trigger"
          VendorRequest.create(vendor_request_attributes)
        end

        send_creadentials_mail(user, params[:password])
        send_user_registered_mail_to_admin(user, params[:token], user_registered_through_trigger)
      end
      EventMember.where(invite_team_token: params[:token]).update_all(status: 'approved')
    end

    private

    def send_creadentials_mail(user, pswd)
      UserMailer.send_creadentials_mail(user, pswd).deliver!
    end

    def send_user_registered_mail_to_admin(user, token, user_registered_through_trigger)

      if user_registered_through_trigger == "Speaker Invite Trigger"
        # No trigger for speaker
      else
        event_member = EventMember.find_by(invite_team_token: token)
        UserMailer.send_user_registered_mail_to_admin(user, Event.find(event_member.event_id), user_registered_through_trigger).deliver!
      end
    end
  end
end
