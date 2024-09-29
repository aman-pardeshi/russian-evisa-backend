class MailInterceptor
  def self.delivering_email(message)
    message.subject = "[Intercepted Eventible] #{message.to} #{message.subject}"
    message.to = ENV['DEV_TEAM_EMAILS']
  end
end

unless Rails.env.production?
  ActionMailer::Base.register_interceptor(MailInterceptor)
end
