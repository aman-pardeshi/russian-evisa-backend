class OrganizerEnquiryMailer < ApplicationMailer

  def enquiry_mail(user)
    @user = user
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.enquiry_mail"))
  end
end
