class SendEmailReportJob < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(email_report, current_user)
    file_path = "#{Rails.root}/public/email_report.csv"
    headers = ["User ID", "Name", "Email", "Designation", "Company", "User Status", "Event ID", "Event Name", "Event Edition", "Event Category", "Country", "Mail Trigger", "Mail Opened", "Link Clicked", "Unsubscibe Status", "Has Organizer Replied", "Embeded Audio Review", "Embeded Badge", "Downloaded PEA", "Bounce Status"]
    
    CSV.open(file_path, "wb") do |csv|
      csv << headers

      email_report.each do |entry|
        user = load_user(entry.user_id)
        event = load_event(entry.event_id)
        review_ids = event.reviews.pluck("id").uniq
        details = [
          user[:id],
          user[:name],
          user[:email],
          user[:designation],
          user[:company_name],
          entry.user_status,
          event.id,
          event.title,
          event.edition,
          event.category,
          event.country.name,
          entry.mail_trigger,
          entry.mail_opened,
          entry.link_clicked,
          entry.unsubscribe_status,
          load_comments_details(review_ids, user[:id], entry.mail_trigger),
          entry.mail_trigger == "Audio Review" ? entry.action_taken : "",
          entry.mail_trigger == "Badge Trigger" ? entry.action_taken : "",
          entry.mail_trigger == "Post Event Analysis" ? entry.action_taken : "",
          entry.bounce_status
        ]

        details = details.flatten
        csv << details
      end
    end

    UserMailer.send_email_report_on_mail(current_user, file_path).deliver!
    system("rm -rf #{file_path}")
  end

  private

  def load_user(id)
    user = User.find(id)
    user_obj = {
      id: user.id,
      name: user.name,
      email: user.email,
      designation: user.designation,
      company_name: user.company_name
    }
  end

  def load_event(id)
    Event.find(id)
  end

  def load_comments_details(review_ids, user_id, mail_trigger)
    comments = Comment.where(review_id: review_ids, user_id: user_id)

    mail_trigger == "Reply Trigger" ? 
    comments.present? ? "true" : "" : ""
    
  end
end
