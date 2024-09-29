namespace "pre_event_triggers" do
  desc "send_organizer_trigger"
  task :send_organizer_trigger => :environment do

    # For sending organizer reply trigger
    event_ids_for_three_review = EmailTracker.where(mail_trigger: "3 Reviews")

    filtered_event_ids = event_ids_for_three_review.select{|entry| Date.current.mjd - entry.created_at.to_date.mjd == 2}.pluck("event_id").uniq

    filtered_event_ids.each do |id|
      organizers_ids = EventMember.where(event_id: id, status: 'approved').pluck("user_id").uniq

      event = Event.find(id)

      organizers = User.where(id: organizers_ids, unsubscribe_status: nil)
      job_title_suppression_list = ["CEO", "Demand Generation"]
      organizers.each do |member|

        if member.role == "organizer" and !job_title_suppression_list.include?(member.position.name)
          tracking_details = EmailTracker.new(user_id: member.id, event_id: event.id, mail_trigger: "Reply Trigger", user_status: "Existing")
          tracker_id = 0
          if tracking_details.save!
            tracker_id = EmailTracker.where(user_id: member.id, event_id: event.id, mail_trigger: "Reply Trigger").last.id
          end
          UserMailer.send_reply_trigger_existing_user(event, member, tracker_id).deliver!
        elsif !(member.role == 'admin' || member.role == 'moderator') and !job_title_suppression_list.include?(member.position.name)
          tracking_details = EmailTracker.new(user_id: member.id, event_id: event.id, mail_trigger: "Reply Trigger", user_status: "New")
          tracker_id = 0
          if tracking_details.save!
            tracker_id = EmailTracker.where(user_id: member.id, event_id: event.id, mail_trigger: "Reply Trigger").last.id
          end
          token = EventMember.find_by(event_id: event.id, user_id: member.id).invite_team_token
          UserMailer.send_reply_trigger_propective_user(event, member, token, tracker_id).deliver!
        end
      end
    end

    def sending_triggers_to_organizer(organizer, event, trigger_name)
      if organizer.role == "organizer"
        tracking_details = EmailTracker.new(user_id: organizer.id, event_id: event.id, mail_trigger: trigger_name, user_status: "Existing")
        tracker_id = 0
        if tracking_details.save!
          tracker_id = EmailTracker.where(user_id: organizer.id, event_id: event.id, mail_trigger: trigger_name).order(created_at: :desc).first.id
        end

        if trigger_name == "Find a Speaker"
          UserMailer.discover_event_speaker_trigger_existing_user(event, organizer, tracker_id).deliver!
        elsif trigger_name == "Visitor Intent 2" and @visitor_details.present? and @visitor_details.count == 3
          UserMailer.demand_gen_trigger_existing_user(event, organizer, tracker_id, @visitor_details).deliver!
        elsif trigger_name == "Banner Trigger"
          UserMailer.add_banner_to_eventible_existing_user(event, organizer, tracker_id).deliver!
        elsif trigger_name == "Media Partnership"
          UserMailer.send_promotion_trigger_existing_user(event, organizer, tracker_id).deliver!
        elsif trigger_name == "Visitor Intent 1" and @visitor_details.present? and @visitor_details.count == 3
          UserMailer.drive_registration_trigger_existing_user(event, organizer, tracker_id, @visitor_details).deliver!
        elsif trigger_name == "Share Review"
          UserMailer.organizer_review_link_trigger_existing_user(event, organizer, tracker_id).deliver!
        end

      elsif !(organizer.role == 'admin' || organizer.role == 'moderator')
        tracking_details = EmailTracker.new(user_id: organizer.id, event_id: event.id, mail_trigger: trigger_name, user_status: "New")
        tracker_id = 0
        if tracking_details.save!
          tracker_id = EmailTracker.where(user_id: organizer.id, event_id: event.id, mail_trigger: trigger_name).order(created_at: :desc).first.id
        end
        token = EventMember.find_by(event_id: event.id, user_id: organizer.id).invite_team_token

        if trigger_name == "Find a Speaker"
          UserMailer.discover_event_speaker_trigger_prospective_user(event, organizer, token, tracker_id).deliver!
        elsif trigger_name == "Visitor Intent 2" and @visitor_details.present? and @visitor_details.count == 3
          UserMailer.demand_gen_trigger_prospective_user(event, organizer, token, tracker_id, @visitor_details).deliver!
          elsif trigger_name == "Banner Trigger"
          UserMailer.add_banner_to_eventible_prospective_user(event, organizer, token, tracker_id).deliver!
        elsif trigger_name == "Media Partnership"
          UserMailer.send_promotion_trigger_prospective_user(event, organizer, token, tracker_id).deliver!
        elsif trigger_name == "Visitor Intent 1" and @visitor_details.present? and @visitor_details.count == 3
          UserMailer.drive_registration_trigger_prospective_user(event, organizer, token, tracker_id, @visitor_details).deliver!
        elsif trigger_name == "Share Review"
          UserMailer.organizer_review_link_trigger_prospective_user(event, organizer, token, tracker_id).deliver!
        end
      end
    end

    # For Pre-event triggers 
    upcoming_events = Event.where("start_date > ?", DateTime.current).approved

    day_of_last_trigger = 70

    filtered_upcoming_events = upcoming_events.select{|event| 
      event.pre_event_trigger == false and event.start_date.to_date.mjd - Date.current.mjd >= day_of_last_trigger }
      
    filtered_upcoming_events.each do |event|
      days_till_start_date = event.start_date.to_date.mjd - Date.current.mjd
      puts "#{event.id}, #{event.title}, #{days_till_start_date}"

      organizers_ids = EventMember.where(event_id: event.id, status: 'approved').pluck("user_id").uniq

      organizers = User.where(id: organizers_ids, unsubscribe_status: nil)
      
      @visited_page = VisitedPage.where(category: 'event', page_id: event.id).limit(3)
      @visitor_details = if @visited_page.present?
        @visited_page.map{|vp| vp.visitor_detail}
      end

      organizers.each_with_index do |member, index|
        case days_till_start_date
          when 82 
            # Speaker Directory 
            if !['CEO', 'Demand Generation'].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Find a Speaker"
              )
            end
          when 80
            # Drive registrations with eventible
            if !["CEO", "Event", "Digital", "Social Media", "Content"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Visitor Intent 1"
              )
            end
          when 79
            # Add a banner
            if !["CEO", "Marketing", "Event", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Banner Trigger"
              )
            end
          when 74
            # Partner with Eventible for Event promotion
            if !["CEO", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Media Partnership"
              )
            end
          when 72
            # Rev up your demand gen
            if !["CEO", "Event", "Digital", "Social Media", "Content"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Visitor Intent 2"
              )
            end
          when 70
            # Boost your event with your atteendees reviews
            if !["CEO", "Marketing", "Event", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Share Review"
              )
            end
        end
      end
    end


    # For sending pre-event trigger forcefully 
    upcomging_events_for_pre_event_trigger = upcoming_events.select{|event| 
      if event.approved_at.present? 
        event.pre_event_trigger == true and 
        Date.current.mjd - event.approved_at.to_date.mjd < 15 and 
        event.start_date.to_date.mjd - Date.current.mjd >= 30
      end
    }

    upcomging_events_for_pre_event_trigger.each do |event|
      days_till_event_approval = event.approved_at ? Date.current.mjd - event.approved_at.to_date.mjd : 0
      puts "#{event.id}, #{event.title}, #{days_till_event_approval}, #{event.pre_event_trigger}"

      organizers_ids = EventMember.where(event_id: event.id, status: 'approved').pluck("user_id").uniq

      organizers = User.where(id: organizers_ids, unsubscribe_status: nil)

      organizers.each_with_index do |member, index|
        case days_till_event_approval
          when 2 
            # Speaker Directory
            if !['CEO', 'Demand Generation'].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Find a Speaker"
              )
            end
          when 4
            # Drive registrations with eventible
            if !["CEO", "Event", "Digital", "Social Media", "Content"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Visitor Intent 1"
              )
            end
          when 5
            # Add a banner
            if !["CEO", "Marketing", "Event", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Banner Trigger"
              )
            end
          when 10
            # Partner with Eventible for Event promotion
            if !["CEO", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Media Partnership"
              )
            end
          when 12
            # Rev up your demand gen
            if !["CEO", "Event", "Digital", "Social Media", "Content"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Visitor Intent 2"
              )
            end
          when 14
            # Boost your event with your atteendees reviews
            if !["CEO", "Marketing", "Event", "Demand Generation"].include?(member.position.name)
              sending_triggers_to_organizer(
                member, event, "Share Review"
              )
            end
        end
      end
    end
  end
end