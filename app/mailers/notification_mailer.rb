class NotificationMailer < ApplicationMailer

  def send_acknowledgement_mail(record)
    @event_name = Event.where(id: record.resource_id)[0].title
    @user = User.where(id: record.user_id)[0]
    mail(to: @user.email, subject: "Your request on Eventible has been accepted.")
  end

  def send_upcoming_event_notification(user, event)
    @event_name = event.title
    @user = user
    @event_date = event.start_date.to_date.mjd - Date.current.mjd
    @event_date_string = ""
    @event_landing_url = "#{ENV.fetch("FRONTEND_URL")}/#{event.category}/#{event.slug}"

    if @event_date == 2
      @event_date_string = "2 days!"
    elsif @event_date == 1
      @event_date_string = " 1 day!"
    end

    mail(to: @user.email, subject: "#{@event_name} begins in #{@event_date_string}")
  end
end
