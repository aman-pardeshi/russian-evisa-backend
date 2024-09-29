namespace "send_notification" do
  desc "send_upcoming_event_notification"
  task :send_upcoming_event_notification => :environment do
    upcoming_events = Event.where("start_date > ?", DateTime.current).approved

    upcoming_event_ids = upcoming_events.map do |event|
      if event.parent_id
        event.parent_id
      else
        event.id
      end
    end

    notification_to_be_sent = UserInsight.where(resource_id: upcoming_event_ids, is_notified: true)

    notification_to_be_sent.map do |entry|
      user = User.where(id: entry.user_id).first

      target_event_with_parent = 
      upcoming_events.where(parent_id: entry.resource_id)

      target_event = upcoming_events.where(id: entry.resource_id).first

      # if target_event_with_parent.length != 0 
      #   target_event_with_parent.map {|e| puts "event with parent => #{e.id} #{e.title}"}
      # else 
      #   puts "No event with target"
      # end

      # if target_event
      #   puts "target_event => #{target_event.id}, #{target_event.title}"
      # else
      #   puts "No target event"
      # end
     
      if target_event
        if (target_event.start_date.to_date.mjd - Date.current.mjd) <= 2 and
          (target_event.start_date.to_date.mjd - Date.current.mjd) > 0
          NotificationMailer.send_upcoming_event_notification(user, target_event).deliver!
        end
      elsif target_event_with_parent.length > 0
        event = target_event_with_parent.first
        if (event.start_date.to_date.mjd - Date.current.mjd) <= 2 and
          (event.start_date.to_date.mjd - Date.current.mjd) > 0
          NotificationMailer.send_upcoming_event_notification(user, event).deliver!
        end
      end
    end
  end
end