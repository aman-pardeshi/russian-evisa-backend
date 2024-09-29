require 'securerandom'

module V1::TeamMember::Operation
  class InviteTeamMember < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'email')

    step :parse_params

    step :load_user
    fail V1::Api::Macro.SomethingWentWrong

    # step :generate_invite_token

    step :create_team_invite
    fail :failed_to_create_team_invite

    step :send_team_invite

    def check_params(ctx, params:, **)
      params[:email].present?
    end

    def parse_params(ctx, params:, **)
      ctx[:updated_params] = params.permit(:name, :email, :designation, :company_name, :status)
    end

    def load_user(ctx, **)
      user = User.find_by(email: ctx[:updated_params][:email])
      if user.present?
        ctx[:invite_member] = user
        return ctx[:invite_member]
      end
      ctx[:updated_params][:password] = SecureRandom.hex(8)
      ctx[:updated_params][:password_confirmation] = ctx[:updated_params][:password]
      ctx[:updated_params][:role] = 'organizer'
      # ctx[:updated_params][:confirmation_token] = JWT.encode(ctx[:updated_params], Rails.application.credentials.secret_key_base)
      ctx[:invite_member] = create_user(ctx[:updated_params])
      # send_creadentials_mail(ctx[:invite_member], ctx[:updated_params][:password])
    end

    # def generate_invite_token(ctx, updated_params:, **)
    #   ctx[:token] = JWT.encode(updated_params, Rails.application.credentials.secret_key_base)
    # end

    def create_team_invite(ctx, updated_params:, invite_member:, current_user:, **)
      ctx[:token] = JWT.encode(updated_params, Rails.application.credentials.secret_key_base)
      current_user.events.map do |event|
        EventMember.create(user_id: invite_member.id, invited_by: current_user.id, event_id: event.id, status: "pending", invite_team_token: ctx[:token])
      end
    end

    def failed_to_create_team_invite(ctx, **)
      ctx[:error] = I18n.t('error.action', action:'Failed to add Team Member.')
    end

    def send_team_invite(ctx, invite_member:, token:, current_user:,  **)
      UserMailer.send_team_invite_mail(invite_member, token, current_user, ctx[:updated_params][:password]).deliver!
    end


    private

    def create_user(params)
      user = User.new(params)
      user.skip_confirmation!
      user.skip_password_validation = true
      user.save!
      return user
    end

    # def send_creadentials_mail(user, pswd)
    #   @user = user
    #   @pswd = pswd
    #   UserMailer.send_creadentials_mail(@user, @pswd).deliver!
    # end
  end
end
