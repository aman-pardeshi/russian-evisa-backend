class UserMailer < ApplicationMailer

  def deactivate_account(record)
    @user = record
    mail(to: record.email,  subject: I18n.t("mailer.deactivate_account.subject"))
  end

  def send_creadentials_mail(user, pswd)
    @user = user
    @pswd = pswd
  
    mail(to: @user.email, subject: "Your #{@user.role == "speaker" ? "Gazebo" : "my."} credentials are here!")
  end


  def send_notification_to_support(user, subject)
    @user = user
    @role = @user.role.present? ? @user.role : "organizer"
    mail(to: 'support@.com', subject: subject)
  end


  def send_mail_to_admin_sample_sheet(user, file)
    @user = user
    attachments["sample_pre_tag_sheet.csv"] = open(file).read()
    mail(to: @user.email, subject: "Sample Sheet for Pre Tag Events")
  end

  def send_otp_for_new_user(email, otp)
    @otp = otp
    mail(to: email, subject: "One Time Password for Email verification")
  end

  def first_application_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Complete Your Russian eVisa Application to Secure Your Travel Plans!')
  end

  def second_application_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Don’t Miss Out! Finalize Your Russian eVisa Application')
  end

  def third_application_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Your Russian eVisa Application is Waiting for You!')
  end
  
  def forth_application_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Final Chance to Complete Your Russian eVisa Application')
  end

  def final_application_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Your Russian eVisa Application is Inactive – Reactivate Now!')
  end

  def application_submitted_acknowledge(user)
    @user = user
    mail(to: user.email, subject: 'Your Russian eVisa Application is Successfully Submitted!')
  end

  def application_approval_email(application)
    @user = application.user
    @application = application
    attachments["approval_document.pdf"] = @application.approval_document.url.present? ? open("#{@application.approval_document.url}").read() : ''
    mail(to: @user.email, subject: 'Your Russian eVisa Has Been Approved!')
  end

  def application_rejection_email(application
    )
    @application = application
    @user = application.user
    mail(to: @user.email, subject: 'Update on Your Russian eVisa Application – Visa Rejected')
  end
end

# Helpful functions

def format_number(number)
  num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
  num_groups.map(&:join).join(',').reverse
end
