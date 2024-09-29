class SendEventsExport < ApplicationJob

  require 'csv'
  queue_as :default

  def perform(events, current_user)

    file_path = "#{Rails.root}/public/events_export.csv"
    headers = [
      "ID", 
      "Title", 
      "Edition", 
      "Category", 
      "Logo", 
      "Banner", 
      "Description", 
      "Event Type", 
      "Start Date", 
      "End Date", 
      "Country",
      "Parent Id",
      "Created By",
      "Owner",
      "Registration URL", 
      "Price", 
      "Coupon Code", 
      "Text Reviews",
      "Audio Reviews",
      "Total Reivews",
      "No. of Images",
      "No of Badges",
      "Eventible Score", 
      "Brand Score", 
      "Attendee Brand Score",
      "Speaker Brand Score",
      "Sponsor Brand Score",
      "Networking Score",
      "Learning Score",
      "Discount Percentage", 
      "Status", 
      "Approved At",
      "Reject Note", 
      "Is Paid", 
      "Created At",
      "Updated At",
      "URL Name",
      "Timezone",
      "Slug",
      "Old Slug",
      "Brand URL",
      "Image Alt Title",
      "Is Yearly Event",
      "Report Download Status",
      "Review Word Count",
      "Pre Event Trigger"
    ]

    CSV.open(file_path, "wb") do |csv|
      csv << headers
        events.each do |entry|

        details = [
          entry.id,
          entry.title,
          entry.edition,
          entry.category,
          entry.logo,
          entry.banner,
          entry.description,
          entry.event_type.humanize,
          entry.start_date,
          entry.end_date,
          entry.country.name,
          entry.parent_id,
          entry.created_by.name, 
          entry.owner.name,
          entry.registration_url,
          entry.price,
          entry.coupoun_code,
          entry.total_review - entry.audio_reviews.where(status: "approved").count,
          entry.audio_reviews.where(status: "approved").count,
          entry.total_review,
          entry.event_images.count,
          entry.badges.count,
          entry.eventible_score,
          entry.brand_score,
          entry.attendee_brand_score,
          entry.speaker_brand_score,
          entry.sponsor_brand_score,
          entry.networking_score,
          entry.learning_score,
          entry.discount_percentage,
          entry.status.humanize,
          entry.approved_at,
          entry.reject_note,
          entry.is_paid,
          entry.created_at,
          entry.updated_at,
          entry.url_name,
          entry.timezone,
          entry.slug,
          entry.old_slug,
          entry.brand_url,
          entry.image_alt_title,
          entry.is_yearly_event,
          entry.report_download_status,
          entry.review_word_count,
          entry.pre_event_trigger
        ]

        details = details.flatten
        csv << details
      end
    end

    # add usermailer functionality
    UserMailer.send_email_report_on_mail(current_user, file_path).deliver!
    system("rm -rf #{file_path}")
  end
end