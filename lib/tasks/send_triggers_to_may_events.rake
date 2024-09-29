namespace "send_trigger_may_month_events" do
  desc "review_milestones_may_month_triggers"
  task :send_may_month_triggers => :environment do
    target_events = [499, 489, 514, 523, 493]
    target_events.map do |event_id|
      event = Event.find(event_id)
      if (event.total_review == 3 || event.total_review == 4)
        event_first_three_review(event)
      end
      if (event.total_review >= 5)
        event_more_than_five_reviews(event)
      end
    end
    puts 'Review miletsones triggered successfully'
  end
end

def event_first_three_review(event)
  event_ids = EventMember.where(event_id: event.id).pluck(:user_id).uniq
  event_user = User.where(id: event_ids)
  event_user.map do |member|
    if member.role == 'organizer'
      UserMailer.send_first_event_review_mail_existing_user(event, member).deliver!
    else
      if !(member.role == 'admin' || member.role == 'moderator')
        token = EventMember.find_by(event_id: event.id, user_id: member.id).invite_team_token
        UserMailer.send_first_event_review_mail(event, member, token).deliver!
      end
    end
  end
end

def event_more_than_five_reviews(event)
  event_ids = EventMember.where(event_id: event.id).pluck(:user_id).uniq
  event_user = User.where(id: event_ids)
  event_user.map do |member|
    if member.role == 'organizer'
      UserMailer.send_review_count_increases_mail_for_existing_user(event, member).deliver!
    else
      if !(member.role == 'admin' || member.role == 'moderator')
        token = EventMember.find_by(event_id: event.id, user_id: member.id).invite_team_token
        UserMailer.send_review_count_increases_mail(event, member, token).deliver!
      end
    end
  end
end
