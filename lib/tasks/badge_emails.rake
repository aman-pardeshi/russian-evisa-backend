namespace "badge_emails_testing" do
  desc "badge_email_trigger"
  task :badge_email => :environment do
    event = Event.find(266)

    trigger_mail_for_exisiting = BadgeMailer.method(:most_popular_badge)
    trigger_mail_for_new = BadgeMailer.method(:most_popular_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:networking_badge)
    trigger_mail_for_new = BadgeMailer.method(:networking_badge_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:most_recommended_badge)
    trigger_mail_for_new = BadgeMailer.method(:recommended_badge_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:best_for_learning_badge)
    trigger_mail_for_new = BadgeMailer.method(:learning_badge_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:top_rated_badge)
    trigger_mail_for_new = BadgeMailer.method(:top_rated_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:top_one_badge)
    trigger_mail_for_new = BadgeMailer.method(:top_one_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:top_third_badge)
    trigger_mail_for_new = BadgeMailer.method(:top_third_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    trigger_mail_for_exisiting = BadgeMailer.method(:top_tenth_badge)
    trigger_mail_for_new = BadgeMailer.method(:top_tenth_new_user)
    send_badge_triggers(event, trigger_mail_for_exisiting, trigger_mail_for_new)

    BadgeMailer.standard_badge(event, user).deliver!
    puts 'successfully sent all the badges'
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
