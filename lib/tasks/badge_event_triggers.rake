namespace "popular_networking_badge_trigger" do
  desc "send_email_triggers"
  task :popular_networking_badge => :environment do
    target_events = Event.where(start_date: ('2021-08-01 00:00:00'..'2022-05-31 00:00:00')).where(status: 'approved')
    badge_approved_events = target_events.where('total_review >= ?', 8)
    badge_approved_events.map do |event|
      if event.total_review >= 8
        if(Event.new.most_popular_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:most_popular_badge)
          trigger_mail_for_new = BadgeMailer.method(:most_popular_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end

    badge_approved_events.map do |event|
      if(Event.new.best_for_networking_badge(event.id))
        trigger_mail_for_exisiting = BadgeMailer.method(:networking_badge)
        trigger_mail_for_new = BadgeMailer.method(:networking_badge_new_user)
        send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
      end
    end

    puts "Most popular and networking badges triggered successfully"
  end
end

def send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
  event_ids = EventMember.where(event_id: event.id).pluck(:user_id).uniq
  event_user = User.where(id: event_ids)
  event_user.map do |member|
    if member.role == 'organizer'
      trigger_mail_for_exisiting.call(event, member).deliver!
    else
      if !(member.role == 'admin' || member.role == 'moderator')
        token = EventMember.find_by(event_id: event.id, user_id: member.id).invite_team_token
        trigger_mail_for_new.call(event, member, token).deliver!
      end
    end
  end
end
