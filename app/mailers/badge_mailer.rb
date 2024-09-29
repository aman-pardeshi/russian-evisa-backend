class BadgeMailer < ApplicationMailer

  def most_popular_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Your event is popular! #{Emoji.find_by_alias('heart_eyes').raw}")
  end

  def most_popular_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Your event is popular! #{Emoji.find_by_alias('heart_eyes').raw}")
  end

  def networking_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Attendees loved #{event.title} for Networking! #{Emoji.find_by_alias('heart_eyes').raw}")
  end

  def networking_badge_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Attendees loved #{event.title} for Networking! #{Emoji.find_by_alias('heart_eyes').raw}")
  end

  def most_recommended_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: " Guess the Most Recommended event of 2022? #{Emoji.find_by_alias('wink').raw}")
  end

  def recommended_badge_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: " Guess the Most Recommended event of 2022? #{Emoji.find_by_alias('wink').raw}")
  end

  def best_for_learning_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Huge win for #{@event.title}")
  end

  def learning_badge_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Huge win for #{@event.title}")
  end

  def top_rated_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Well done team! #{Emoji.find_by_alias('clap').raw}")
  end

  def top_rated_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Well done team! #{Emoji.find_by_alias('clap').raw}")
  end

  def top_one_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Your event made it to the #1 spot #{Emoji.find_by_alias('clap').raw}")
  end

  def top_one_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Your event made it to the #1 spot #{Emoji.find_by_alias('clap').raw}")
  end

  def top_third_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Your event made it to the Top 3! #{Emoji.find_by_alias('clap').raw}")
  end

  def top_third_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Your event made it to the Top 3! #{Emoji.find_by_alias('clap').raw}")
  end

  def top_tenth_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Your event made it to the Top 10! #{Emoji.find_by_alias('clap').raw}")
  end

  def top_tenth_new_user(event, user, token)
    @event = event
    @user = user
    @token = token
    mail(to: @user.email, subject: "Your event made it to the Top 10! #{Emoji.find_by_alias('clap').raw}")
  end

  def standard_badge(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "Your Ratings Badge is here! #{Emoji.find_by_alias('heart_eyes').raw}")
  end
end
