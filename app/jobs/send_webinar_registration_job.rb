class SendWebinarRegistrationJob < ApplicationJob
    require 'csv'
    queue_as :default
  
    def perform(mail_id)

      webinar_registration_list = LibraryUser.where(event_type: "webinar-registration")

      file_path = "#{Rails.root}/public/library_registration_export.csv"
      headers = [
        "ID",
        "First Name",
        "Last Name",
        "Business Email",
        "Company Name",
        "Job title",
        "Registered for",
      ]

      CSV.open(file_path, "wb") do |csv|
        csv << headers
            webinar_registration_list.each do |entry|
                    
            details = [
                entry.id,
                entry.first_name,
                entry.last_name,
                entry.email,
                entry.company_name,
                entry.job_title,
                entry.event_title
            ]
            details = details.flatten
            csv << details
        end
      end
      
        # add usermailer functionality
        UserMailer.send_webinar_registration_report_on_mail(mail_id, file_path).deliver!
        system("rm -rf #{file_path}")

    end 
end