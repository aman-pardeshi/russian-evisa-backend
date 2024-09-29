namespace "send_event_content_trigger" do
  desc "Sending event content trigger for all organizer for one time"
  task :send_trigger => :environment do
  
    events = Event.all.approved.order(id: :desc)

    email_count = 0
    max_emails = if Rails.env.production? 
      500
    else
      10
    end


    events.each do |event|
      break if email_count >= max_emails

      event_members_ids = event.event_members.where(status: "approved").pluck(:user_id)

      organizers = User.where(id: event_members_ids, unsubscribe_status: nil)

      
      organizers.each_with_index do |member, index|
        break if email_count >= max_emails
        unless EmailTracker.where(user_id: member.id, mail_trigger: "Event Content Trigger").present?
          if member.role == "organizer"
            tracking_details = EmailTracker.new(user_id: member.id, event_id: event.id, mail_trigger: "Event Content Trigger", user_status: "Existing")
            
            if tracking_details.save!
              UserMailer.event_content_trigger_existing_user(event, member, tracking_details.id).deliver!
              puts "send to #{member.name}"
              email_count += 1
            end
  
          elsif !(member.role == 'admin' || member.role == 'moderator')
            tracking_details = EmailTracker.new(user_id: member.id, event_id: event.id, mail_trigger: "Event Content Trigger", user_status: "New")
  
            token = EventMember.find_by(event_id: event.id, user_id: member.id).invite_team_token
  
            if tracking_details.save!
              UserMailer.event_content_trigger_prospective_user(event, member, token, tracking_details.id).deliver!
              puts "send to #{member.name}"
              email_count += 1
            end
          end
        end
      end
    end
  end
end
