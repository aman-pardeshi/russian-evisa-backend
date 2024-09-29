class ReviewMailer < ApplicationMailer

  def send_review_approved_mail(record)
    @user = record.reviewer
    @event_name = record.event.title
    @is_reward_for_review = record.is_reward_for_review
    mail(to: @user.email, subject: I18n.t("mailer.review.send_review_approved_mail") )
  end

  def send_review_submitted_mail(record)
    @user = record.reviewer
    @event_name = record.event.title
    @is_reward_for_review = record.is_reward_for_review
    mail(to: @user.email, subject: I18n.t("mailer.review.send_review_submitted_mail"))
  end

  def review_flaged_mail(user, event_name, review_title)
    @review_title = review_title
    @user = user
    @event_name = event_name
    mail(to: @user.email, subject: I18n.t("mailer.review.review_flaged_mail"))
  end

  def admin_notification_flagged_mail(organizer, event_name, review_title, reviewer, flaged_reason)
    @review_title = review_title
    @organizer = organizer
    @event_name = event_name
    @reviewer = reviewer
    @flaged_reason = flaged_reason

    mail(to: ['ag@eventible.com','abakhshi@eventible.com'], subject: "#{@organizer.name} flagged review for #{@event_name}")
  end
end
