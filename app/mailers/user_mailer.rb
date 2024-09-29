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

  def send_newsletter_test_mail(mail_details, email_id)
    @event = mail_details[:event]
    @edition = mail_details[:edition]
    @user= mail_details[:user]
    @newsletter = mail_details[:newsletter]
    @tracking_link = mail_details[:newsletter].present? ? "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@newsletter.id}&type=newsletter" : ""

    mail(to: email_id, subject: "Events Recommended for #{@user.name.split(" ")[0].present? ? @user.name.split(" ")[0] : @user.name}, #{mail_details[:edition].sub(",", "")}")
  end

  def send_newsletter_test_mail_light(mail_details, email_id)
    @event = mail_details[:event]
    @edition = mail_details[:edition]
    @user= mail_details[:user]
    @newsletter = mail_details[:newsletter]
    @tracking_link = mail_details[:newsletter].present? ? "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@newsletter.id}&type=newsletter" : ""

    mail(to: email_id, subject: "Events Recommended for #{@user.name.split(" ")[0].present? ? @user.name.split(" ")[0] : @user.name}, #{mail_details[:edition].sub(",", "")}")
  end

  def send_last_login_activity_mail(user)
    @user = user
    mail(to: @user.email, subject: "#{@user.name} activity on Eventible")
  end

  def send_review_count_increases_mail(event, user, token, tracker_id)
    @user = user
    @event = event
    @token = token
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Woohoo your event is soaring! #{Emoji.find_by_alias('rocket').raw}")
  end

  def send_first_event_review_mail(event, user, token, tracker_id)
    @user = user
    @event = event
    @token = token
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Your event is being talked about!
    ")
  end

  def send_first_event_review_mail_existing_user(event, user, tracker_id)
    @user = user
    @event = event
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Your event is being talked about!")
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

  def send_post_analysis_report(event, user, token, tracker_id)
    @event = event
    @user = user
    @token = token
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Insights from #{@event.title}")
  end

  def send_post_analysis_report_existing_users(event, user, tracker_id)
    @event = event
    @user = user
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    attachments["#{@event.title}.pdf"] = @event.analysis_report.url.present? ? open("#{@event.analysis_report.url}").read() : ''
    mail(to: @user.email, subject: "Insights from #{@event.title}")
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

  def audio_review_mail_existing_user(user, event, audio_url, tracker_id)
    @user = user
    @event = event
    @audio_url = audio_url
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Are these your biggest fans!")
  end

  def audio_review_mail_prospective_user(event, user, token, tracker_id)
    @user = user
    @event = event
    @token = token
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Are these your biggest fans!")
  end

  def send_mail_to_admin(user, file, failed_file)
    @user = user
    attachments["organizer_list.csv"] = open(file).read()
    attachments["failed_organizers_list.csv"] = open(failed_file).read() if failed_file.present?
    mail(to: @user.email, subject: "File Uploaded for Pre tagging events")
  end

  def send_review_count_increases_mail_for_existing_user(event, user, tracker_id)
    @user = user
    @event = event
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Woohoo your event is soaring! #{Emoji.find_by_alias('grin').raw}")
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
  
  def send_reply_trigger_existing_user(event, user, tracker_id)
    @event = event
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Someone’s got to do this!")
  end

  def send_reply_trigger_propective_user(event, user, token, tracker_id)
    @event = event
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Someone’s got to do this!")
  end

  def send_seo_trigger_existing_user(event, user, tracker_id)
    @event = event
    @user = user
    @category = event.job_title.present? ? event.job_title : event.industry
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Convert Audiences to Attendees")
  end

  def send_seo_trigger_prospective_user(event, user, token,tracker_id)
    @event = event
    @user = user
    @category = event.job_title.present? ? event.job_title : event.industry
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Convert Audiences to Attendees")
  end

  def discover_event_speaker_trigger_existing_user(event, user, tracker_id)
    @event = event
    @category = event.job_title.present? ? event.job_title : event.industry
    @speaker_count = format_number(@category.class.to_s == "JobTitle" ? Speaker.where(job_title_id: @category.id).count : Speaker.where(industry_id: @category.id).count)
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Find the hottest speakers for #{@event.title}")
  end

  def discover_event_speaker_trigger_prospective_user(event, user, token, tracker_id)
    @event = event
    @category = event.job_title.present? ? event.job_title : event.industry
    @speaker_count = format_number(@category.class.to_s == "JobTitle" ? Speaker.where(job_title_id: @category.id).count : Speaker.where(industry_id: @category.id).count)
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Find the hottest speakers for #{@event.title}")
  end

  def demand_gen_trigger_existing_user(event, user, tracker_id, visitor_details)
    @event = event
    @user = user
    @visitor_details = visitor_details
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "These accounts are interested in #{@event.title}")
  end

  def demand_gen_trigger_prospective_user(event, user, token, tracker_id, visitor_details)
    @event = event
    @user = user
    @visitor_details = visitor_details
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "These accounts are interested in #{@event.title}")
  end

  def add_banner_to_eventible_existing_user(event, user, tracker_id)
    @event = event
    @category = event.job_title.present? ? event.job_title : event.industry
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Help audiences choose #{@event.title}")
  end

  def add_banner_to_eventible_prospective_user(event, user, token, tracker_id)
    @event = event
    @category = event.job_title.present? ? event.job_title : event.industry
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Help audiences choose #{@event.title}")
  end

  def send_promotion_trigger_existing_user(event, user, tracker_id)
    @event = event
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Eventible x #{@event.title} - Media Partnership")
  end

  def send_promotion_trigger_prospective_user(event, user, token, tracker_id)
    @event = event
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Eventible x #{@event.title} - Media Partnership")
  end

  def drive_registration_trigger_existing_user(event, user, tracker_id, visitor_details)
    @event = event
    @visitor_details = visitor_details
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Audiences are excited for #{@event.title}")
  end
  

  def drive_registration_trigger_prospective_user(event, user, token, tracker_id, visitor_details)
    @event = event
    @visitor_details = visitor_details
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Audiences are excited for #{@event.title}")
  end

  def organizer_review_link_trigger_existing_user(event, user, tracker_id)
    @event = event
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Share the Love – Pull in the Audience")
  end

  def organizer_review_link_trigger_prospective_user(
  event, user, token, tracker_id)
    @event = event
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Share the Love – Pull in the Audience")
  end

  def event_content_trigger_existing_user(event, user, tracker_id)
    @event = event
    @user = user
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Forget Youtube - add your event content here")
  end

  def event_content_trigger_prospective_user(event, user, token, tracker_id)
    @event = event
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"
    mail(to: @user.email, subject: "Forget Youtube - add your event content here")
  end

  def existing_speaker_invite_trigger(user, token, tracker_id)
    @user = user
    @token = token
    @tracker_id = tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}"

    mail(to: @user.email, subject: "#{user.first_name}, update your bio to receive speaking opportunities.")
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
