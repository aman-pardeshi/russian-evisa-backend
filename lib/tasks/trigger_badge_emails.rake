namespace "trigger_badge_emails" do
  #most_popular_badge
  desc "send_most_popular_badge"
  task :most_popular_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.most_popular_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:most_popular_badge)
          trigger_mail_for_new = BadgeMailer.method(:most_popular_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #best_for_networking_badge
  desc "best_for_networking_badge"
  task :networking_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.best_for_networking_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:networking_badge)
          trigger_mail_for_new = BadgeMailer.method(:networking_badge_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #most_recommended_badge
  desc "most_recommended_badge"
  task :recommended_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.most_recommended_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:most_recommended_badge)
          trigger_mail_for_new = BadgeMailer.method(:recommended_badge_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #best_for_learning_badge
  desc "best_for_learning_badge"
  task :learning_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.best_for_learning_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:best_for_learning_badge)
          trigger_mail_for_new = BadgeMailer.method(:learning_badge_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #top_rated_badge
  desc "top_rated_badge"
  task :rated_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.top_rated_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:top_rated_badge)
          trigger_mail_for_new = BadgeMailer.method(:top_rated_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #ranked_one_badge
  desc "ranked_one_badge"
  task :top_one_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.ranked_one_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:top_one_badge)
          trigger_mail_for_new = BadgeMailer.method(:top_one_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #ranked_third_badge
  desc "ranked_third_badge"
  task :top_third_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.ranked_third_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:top_third_badge)
          trigger_mail_for_new = BadgeMailer.method(:top_third_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
  end

  #ranked_tenth_badge
  desc "ranked_tenth_badge"
  task :top_tenth_badge => :environment do
    target_events = Event.where(start_date: (3.months.ago..Time.now)).where(status: 'approved')
    target_events.map do |event|
      if event.total_review >= 9
        if(Event.new.ranked_tenth_badge(event.id))
          trigger_mail_for_exisiting = BadgeMailer.method(:top_tenth_badge)
          trigger_mail_for_new = BadgeMailer.method(:top_tenth_new_user)
          send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)
        end
      end
    end
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
