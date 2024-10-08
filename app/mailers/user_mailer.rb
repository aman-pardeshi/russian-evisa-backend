class UserMailer < ApplicationMailer

  def deactivate_account(record)
    @user = record
    mail(to: record.email,  subject: I18n.t("mailer.deactivate_account.subject"))
  end

  def send_vendor_request_approved_mail(record)
    @record = record
    mail(to: record.email, subject: I18n.t("mailer.send_vendor_request_approved_mail.subject"))
  end

  def user_request_approved_mail_for_speakers_directory(record)
    @record = record
    mail(to: record.email, subject: I18n.t("mailer.user_request_approved_mail_for_speakers_directory.subject"))
  end

  def send_claim_request_approved_mail(event_name, resource)
    @event_name = event_name
    @resource = resource
    mail(to: resource.email, subject: I18n.t('mailer.send_claim_request_approved_mail.subject'))
  end

  def campaign_builder_mail(campaign_builder, user)
    if campaign_builder.agenda_file.present?
      agenda_file = " Agenda file.#{campaign_builder.agenda_file.path.split(".")[-1]}"
      attachments["#{agenda_file}"] = open("#{campaign_builder.agenda_file.url}").read()
    end
    if campaign_builder.suppress_list_file.present?
      suppress_list =
        "Suppress List.#{campaign_builder.suppress_list_file.path.split(".")[-1]}"
      attachments["#{suppress_list}"] =
        open("#{campaign_builder.suppress_list_file.url}").read()
    end
    @campaign_builder = campaign_builder
    @user = user
    @seniorities = Seniority.where(id: campaign_builder.seniorities).pluck(:title)
    @job_titles = JobTitle.where(id: campaign_builder.job_titles).pluck(:name)
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.campaign_builder_mail") )
  end

  def send_event_approved_mail(event)
    @event = event
    @owner = event.owner
    mail(to: @owner.email, subject: I18n.t("mailer.send_event_approved_mail"))
  end

  def send_content_marketing_hub_request_mail(content_marketing)
    @request = content_marketing
    @is_allowed_to_interview = @request.is_allowed_to_interview
    @is_allowed_to_video_interview = @request.is_allowed_to_video_interview
    @is_allowed_to_publish_article = @request.is_allowed_to_publish_article
    @is_open_for_ideas_discussion = @request.is_open_for_ideas_discussion
    mail(to: ENV.fetch("EVENTIBLE_CONTENT_TEAM_EMAILS"),
      subject: I18n.t("mailer.send_content_marketing_hub_request_mail"))
  end

  def send_custom_review_link(event)
    @event = event
    @owner = event.owner
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.send_custom_review_link"))
  end

  def vendor_request_mail(user)
    @user = user
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.vendor_request_mail"))
  end

  def vendor_request_mail_for_speaker_directory(user)
    @user = user
    @user_role = user.role.capitalize
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.vendor_request_mail_for_speaker_directory"))
  end

  def send_review_alert_mail(reviewer, event, title, owner)
    @event_title = event.title
    @organizer = owner
    @reviewer = reviewer
    @title = title
    mail(to: @organizer.email, subject: I18n.t("mailer.send_review_alert_mail"))
  end

  def send_run_campaign_on_your_behalf(user)
    @user = user
    mail(to: ENV.fetch("EVENTIBLE_TEAM_EMAILS"), subject: I18n.t("mailer.send_run_campaign_on_your_behalf"))
  end

  def send_reviews_on_mail(user, file_path, event_title)
    @user = user
    attachments["#{event_title}_reviews.csv"] = open("#{file_path}").read()
    mail(to: user.email, subject: "#{event_title.capitalize} Reviews")
  end

  def send_email_report_on_mail(user, file_path)
    @user = user
    attachments["report.csv"] = open("#{file_path}").read()
    mail(to: user.email, subject: "Report Export")
  end

  def send_cralwer_details_on_mail(user, file_path)
    @user = user
    attachments["crawled-url-details-report.csv"] = open("#{file_path}").read()
    mail(to: user.email, subject: "Crawled Url Report Export")
  end

  def send_webinar_registration_report_on_mail(mail_id, file_path)
    attachments["registration_report.csv"] = open("#{file_path}").read()
    mail(to: mail_id, subject: "Webinar Rgistration Report")
  end

  def notify_reviewer_organizer_comment_mail(organizer, reviewer, organizer_comment, event_name)
    @organizer = organizer
    @reviewer = reviewer
    puts "@reviewer #{@reviewer.inspect}"
    @organizer_comment = organizer_comment
    @event_name = event_name
    mail(to: @reviewer.email, subject: I18n.t("mailer.notify_reviewer_organizer_comment"))
  end

  def edition_is_created_mail(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "New edition added to the event")
  end


  def send_last_login_activity_mail(user)
    @user = user
    mail(to: @user.email, subject: "#{@user.name} activity on Eventible")
  end






  def send_score_increment_mail(user, event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "Event #{@event.title} score increases")
  end

  def send_team_invite_mail(user, token, current_user, pswd)
    @user = user
    @token = token
    @current_user = current_user
    @pswd = pswd
    mail(to: @user.email, subject: "#{@current_user.name} from your organization has invited you to my.eventible")
  end

  def send_creadentials_mail(user, pswd)
    @user = user
    @pswd = pswd
  
    mail(to: @user.email, subject: "Your #{@user.role == "speaker" ? "Gazebo" : "my.eventible"} credentials are here!")
  end

  def send_pre_tag_mail_to_new_user(user, token, current_user, pswd)
    @user = user
    @token = token
    @current_user = current_user
    @pswd = pswd
    mail(to: @user.email, subject: "Welocome #{@user.name} to Eventible")
  end

  def send_pre_tag_mail_to_the_existing_user(user, token, current_user, pswd)
    @user = user
    @token = token
    @current_user = current_user
    @pswd = pswd
    mail(to: @user.email, subject: "Eventible mail for the existing users")
  end

  def send_notification_to_support(user, subject)
    @user = user
    @role = @user.role.present? ? @user.role : "organizer"
    mail(to: 'support@eventible.com', subject: subject)
  end

  def send_mail_to_admin(user, file, failed_file)
    @user = user
    attachments["organizer_list.csv"] = open(file).read()
    attachments["failed_organizers_list.csv"] = open(failed_file).read() if failed_file.present?
    mail(to: @user.email, subject: "File Uploaded for Pre tagging events")
  end

  def send_mail_to_admin_sample_sheet(user, file)
    @user = user
    attachments["sample_pre_tag_sheet.csv"] = open(file).read()
    mail(to: @user.email, subject: "Sample Sheet for Pre Tag Events")
  end

  def send_user_registered_mail_to_admin(user, event, trigger_name)
    @user = user
    @event = event
    @trigger_name = trigger_name
    post_event_triggers = ["Find a Speaker", "Visitor Intent 1", "Banner Trigger", "Media Partnership", "Visitor Intent 2", "Share Review"]
    @is_future_event = post_event_triggers.include?(@trigger_name) ? "Future Event" : "Past Event"
    mail(to: ['ag@eventible.com','abakhshi@eventible.in'], subject: "New User Alert: #{@user.name}")
  end


  def send_library_mail_to_user(library_user)
    @library_user = library_user
    mail(to: @library_user.email, from: "campaigns@eventible.com", subject: "Thank You For Requesting For '#{@library_user.event_title}'")
  end

  def profile_verification_acknowledgement(user, tracker_id)
    @user = user
    @tracker_id = tracker_id
    mail(to: @user.email, subject: "#{user.first_name}, thanks for updating your speaker profile!")
  end

  def profile_verification_approved(user, tracker_id)
    @user = user
    @tracker_id = tracker_id
    mail(to: @user.email, subject: "#{user.first_name}, your updated profile is now live.")
  end

  def send_speaker_registered_mail_to_admin(user, trigger_name)
    @user = user
    @trigger_name = trigger_name

    mail(to: ['ag@eventible.com','abakhshi@eventible.in'], subject: "New Speaker Alert: #{@user.name}")
  end

  def send_custom_mail_to_user(user)
    @user = user

    mail(to: user.email, subject: "Happy Holidays from Eventible!🎄")
  end

  def send_banner_dimensions_mail(email, event, organizer)
    @event = event
    @organizer = organizer
    mail(to: email, subject: "Banner Design Request for Event Landing Page on Eventible")
  end
end


# Helpful functions

def format_number(number)
  num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
  num_groups.map(&:join).join(',').reverse
end
