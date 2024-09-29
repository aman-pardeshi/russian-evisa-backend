module V1::User::Operation
  class UnsubscribeUser < Trailblazer::Operation

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'id')

    step :load_user
    fail :failed_to_load_user

    step :update_unsubscribe_status

    step :send_notification_to_support

    def check_params(ctx, params:, **)
      params[:id].present? && params[:email].present?
    end

    def load_user(ctx, params:, **)
      if params[:pixel_id].present?
        if params[:type] == "newsletter"
          ctx[:tracker] = Newsletter.find(params[:pixel_id])
        else 
          ctx[:tracker] = EmailTracker.find(params[:pixel_id])
        end
      end

      if params[:subscriber].present? && params[:subscriber] == "guest"
        ctx[:user] = Guest.find(params[:id])
      else
        ctx[:user] = User.find(params[:id])
      end
      
    end

    def failed_to_load_user(ctx, params:, **)
      ctx[:error] = I18n.t('errors.messages.not_found')
    end

    def update_unsubscribe_status(ctx, params, **)
      if ctx[:tracker].present?
        ctx[:tracker].update(unsubscribe_status: true)
      end
      ctx[:user].update(unsubscribe_status: true)
    end

    def send_notification_to_support(ctx, params, **)
      if ctx[:tracker].present?
        if ctx[:tracker].class.name == "Newsletter"
          UserMailer.send_notification_to_support(ctx[:user], "Newsletter unsubscription notification").deliver!
        else
          send_mail(ctx[:user])
        end
      else
        send_mail(ctx[:user])
      end
    end

    def send_mail(user)
      if user.role == "organizer"
        UserMailer.send_notification_to_support(user, "Organizer unsubscription notification").deliver!
      elsif user.role == "speaker"
        UserMailer.send_notification_to_support(user, "Speaker unsubscription notification").deliver!
      else
        UserMailer.send_notification_to_support(user, "Unsubscription notification").deliver!
      end
    end
    
  end
end
