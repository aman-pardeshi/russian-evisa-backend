class AdminMailer < ApplicationMailer

  def database_backup(filename, time, size)
    @filename = filename
    formatted_time = time.strftime('%d %b %Y %H:%M')
    mail(
      to: ENV.fetch("DEV_TEAM_EMAILS"),
      subject: I18n.t('mailer.database_backup.subject', time: formatted_time, size: size)
    )
  end

  def notify_admin_event_edit(user, event)
    @user = user
    @event = event
    mail(to: ['ag@eventible.com','abakhshi@eventible.in'], subject: "#{@user.name} updated event: #{@event.title}")
  end

  def notify_admin_organizer_reply(organizer, reviewer, comment, event)
    @organizer = organizer
    @reviewer = reviewer
    @comment = comment
    @event = event
    mail(to: ['ag@eventible.com','abakhshi@eventible.in'], subject: "An organizer replied to a review")
  end

  def notify_admin_new_application(user, application)
    @user = user
    @application = application
    mail(to: ['admin@russianevisa.com'], subject: "New Payment Received – Russian eVisa Application for #{user.name}")
  end
end
