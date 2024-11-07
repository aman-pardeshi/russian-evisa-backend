class AdminMailer < ApplicationMailer

  def database_backup(filename, time, size)
    @filename = filename
    formatted_time = time.strftime('%d %b %Y %H:%M')
    mail(
      to: ENV.fetch("DEV_TEAM_EMAILS"),
      subject: I18n.t('mailer.database_backup.subject', time: formatted_time, size: size)
    )
  end


  def notify_admin_new_application(user, application)
    @user = user
    @application = application
    mail(to: ['saransh@techmidori.com', 'amnprdsi@gmail.com'], subject: "New Payment Received – Russian eVisa Application for #{user.name}")
  end
end
