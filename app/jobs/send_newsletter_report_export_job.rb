class SendNewsletterReportExportJob < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(newsletters, current_user)
    file_path = "#{Rails.root}/public/newsletter_report.csv"
    headers = [
      "Month",
      "Year",
      "Category",
      "Dark Mode",
      "Event Id",
      "Event Title",
      "Interested Link Clicked",
      "Subscriber Type",
      "Subscriber Name",
      "Subscriber Email",
      "Designation",
      "Company Name",
      "Mail Opened",
      "Unsubcribe Status",
      "Bounce Status",
    ]

    CSV.open(file_path, "wb") do |csv|
      csv << headers
      newsletters.each do |newsletter|

        newsletter_events = newsletter.newsletter_events

        newsletter_events.each do |newsletter_event|
          details = [
            newsletter.month,
            newsletter.year,
            newsletter.category,
            newsletter.is_dark_mode,
            newsletter_event.event.id,
            newsletter_event.event.title,
            newsletter_event.interested_link_clicked,
            newsletter.subscriber_type,
            newsletter.subscriber.name,
            newsletter.subscriber.email,
            newsletter.subscriber.designation,
            newsletter.subscriber.company_name,
            newsletter.mail_opened,
            newsletter.unsubscribe_status,
            newsletter.bounce_status,
          ]

          details = details.flatten
          csv << details
        end
      end

      total_mail_sent = ["Total Mail Sent = #{newsletters.count}"]

      csv << total_mail_sent
    end

    UserMailer.send_email_report_on_mail(current_user, file_path).deliver!
    system("rm -rf #{file_path}")
  end
end