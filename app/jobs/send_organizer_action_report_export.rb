class SendOrganizerActionReportExport < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(events, current_user)
    file_path = "#{Rails.root}/public/organizer_action.csv"

    headers = [
      "Sr. No.",
      "User Name",
      "Email",
      "Designation",
      "Company",
      "Event ID",
      "Event Title",
      "Trigger Name",
      "Is Token",
      "Action",
      "Action Date",
      "Action Time",
      "Time Spent"
    ]

    
    CSV.open(file_path, "wb") do |csv|
      csv << headers

      index = 1
      events.each do |event|
        if event.event_members.present? 
          event.event_members.each do |event_member|
            user = event_member.user
            user.action_loggers.order(:created_at).each_cons(2) do |action, next_action|
              time_spent = next_action.created_at - action.created_at if next_action
              created_at_datetime = action.created_at.to_datetime
              details = [
                index,
                user.name,
                user.email,
                user.designation,
                user.company_name,
                action.event_id,
                action.event.present? ? action.event.title : "",
                action.trigger,
                action.is_token,
                action.action,
                action.created_at.to_date,
                "#{created_at_datetime.hour}:#{created_at_datetime.minute}:#{created_at_datetime.second}",
                format_duration(time_spent)
              ]
  
              details = details.flatten
              csv << details
              index += 1
            end
          end
        end
      end
    end

    UserMailer.send_email_report_on_mail(current_user, file_path).deliver!
    system("rm -rf #{file_path}")
  end

  def format_duration(duration)
    return nil unless duration

    total_seconds = duration.to_f
    hours = (total_seconds / 3600).to_i
    minutes = ((total_seconds % 3600) / 60).to_i
    seconds = (total_seconds % 60).to_i
    milliseconds = ((total_seconds % 1) * 1000).round

    "#{hours}h #{minutes}m #{seconds}s #{milliseconds}ms"
  end
end