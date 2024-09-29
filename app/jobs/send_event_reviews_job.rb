class SendEventReviewsJob < ApplicationJob

  require 'csv'
  queue_as :default

  TITLE_QUESTION = "Review Title - Please describe your experience in a short sentence"
  LIKE_QUESTION = "What did you like best about the event?"
  IMPROVE_QUESTION = "What could the organizers do to improve the event?"
  RECOMMENDED_QUESTION = "How likely is it that you would recommend this event to a friend or colleague?"
  SPEAKER_QUESTION = "Did you have a favourite speaker or session? Please tell us below"
  PARENT_QUESTION = "Using the scale provided, please rate the event on the following aspects:"

  def perform(user, event)
    event_title = event.title
    reviews = event.reviews.approved
    file_path = "#{Rails.root}/public/#{event.title.gsub(/[^\w]/, "_")}_reviews.csv"
    headers =
    ["gift card amount", "event name", "full name", "attended_as",
    "mode_of_attendance", "company", "designation", "email_id", "Review Title - Please describe your experience in a short sentence",
    "What did you like best about the event?", "What could the organizers do to improve the event?",
    "How likely is it that you would recommend this event to a friend or colleague?",
    "Overall experience", "Value for money", "Networking opportunities(attendee)",
    "Usefulness of participating vendors/sponsors", "Session(s)",
    "Amount of new information learned", "Overall experience(speaker)",
    "Networking opportunities(speaker)", "Technical support for setting up the session",
    "Interactivity with the audience", "Quality of the audience",
    "Overall experience(sponsor)", "Engagement opportunities with the audience",
    "Fit of the audience for my company", "ROI on spend", "Positive brand exposure",
    "Navigation of virtual platform", "Troubleshooting technical issues",
    "Event destination", "Event venue", "Food and beverages at event",
    "Helpfulness of event staff", "Favourite speaker or session"
    ]
    CSV.open(file_path, "wb") do |csv|
      csv << headers
      reviews.each do |review|
        details = [
          review.campaign_link_id.present? ? CampaignLink.find(review.campaign_link_id).reward_amount : "0",
          event_title,
          review.reviewer_name,
          review.attended_as,
          review.mode_of_attendance,
          review.reviewer.company_name,
          review.reviewer.designation,
          review.reviewer.email
        ]
        details = details << load_answers(review)
        details = details.flatten
        csv << details
      end
    end
    UserMailer.send_reviews_on_mail(user, file_path, event_title).deliver!
    system("rm -rf #{file_path}")
  end

  private

  def load_answers(review)
    mode_of_attendance = review.mode_of_attendance
    attended_as = review.attended_as
    submissions = review.review_submissions.joins(:question).order("questions.display_order")
    common_answers = load_common_question_answers(submissions)

    specific_answers =
      if review.attended_as.eql?('attendee')
        load_attendee_answers(submissions)
      elsif review.attended_as.eql?('speaker')
        load_speaker_answers(submissions)
      else
        load_sponsor_answers(submissions)
      end
    common_answers << specific_answers << load_mode_of_attendance_answers(mode_of_attendance, submissions)
  end

  def load_attendee_answers(submissions)
    sub_question_ids =
      Question.find_by(title: PARENT_QUESTION, question_for: 'attendee').sub_questions.ids
    submissions = submissions.where(question_id: sub_question_ids)
    answers = submissions.map { |submission| submission.answer }
    count =
      Question
      .where(
        parent_id:
          Question
          .where(title: PARENT_QUESTION)
          .where.not(question_for: 'attendee')
          .ids
      ).count
    count.times do
      answers << ""
    end
    answers
  end

  def load_speaker_answers(submissions)
    answers = []
    count = Question.find_by(title: PARENT_QUESTION, question_for: 'attendee').sub_questions.count
    count.times do
      answers << ""
    end
    sub_question_ids = Question.find_by(title: PARENT_QUESTION, question_for: 'speaker').sub_questions.ids
    submissions = submissions.where(question_id: sub_question_ids)
    answers << submissions.map { |submission| submission.answer }
    count = Question.find_by(title: PARENT_QUESTION, question_for: 'sponsor').sub_questions.count
    count.times do
      answers << ""
    end
    answers.flatten
  end

  def load_sponsor_answers(submissions)
    answers = []
    count =
      Question
      .where(
        parent_id:
          Question
          .where(title: PARENT_QUESTION)
          .where.not(question_for: 'sponsor')
          .ids
      ).count
    count.times do
      answers << ""
    end
    sub_question_ids = Question.find_by(title: PARENT_QUESTION, question_for: 'sponsor').sub_questions.ids
    submissions = submissions.where(question_id: sub_question_ids)
    answers << submissions.map { |submission| submission.answer }
    answers.flatten
  end

  def load_common_question_answers(submissions)
    submissions=
      submissions
      .where("questions.question_for = #{Question.question_fors[:common]}")
      .where("questions.title != '#{SPEAKER_QUESTION}'")
    [review_title(submissions),
      like_question_answer(submissions),
      improve_question_answer(submissions),
      recommend_question_answer(submissions)
    ]
  end

  def review_title(submissions)
    submissions.
    where(
      question:
        Question.find_by_title(TITLE_QUESTION)
    ).first.answer
  end

  def like_question_answer(submissions)
    submissions.
    where(
      question:
        Question.find_by_title(LIKE_QUESTION)
    ).first.answer
  end

  def improve_question_answer(submissions)
    submissions.
    where(
      question:
        Question.find_by_title(IMPROVE_QUESTION)
    ).first.answer
  end

  def recommend_question_answer(submissions)
    submissions.
    where(
      question:
        Question.find_by_title(RECOMMENDED_QUESTION)
    ).first.answer
  end

  def load_mode_of_attendance_answers(mode_of_attendance, submissions)
    if mode_of_attendance.eql?('online')
      online_answers(submissions)
    else
      in_person_answers(submissions)
    end
  end

  def online_answers(submissions)
    online_sub_question_ids = Question.online.first.sub_questions
    submissions = submissions.where(question_id: online_sub_question_ids)
    submissions.map{ |submission| submission.answer }
  end

  def in_person_answers(submissions)
    answers = []
    online_question_count = Question.online.first.sub_questions.count
    online_question_count.times do
      answers << ""
    end
    in_person_sub_question_ids = Question.in_person.first.sub_questions.ids
    submissions = submissions.where(question_id: in_person_sub_question_ids)
    answers << submissions.map{ |submission| submission.answer }
    answers.flatten
  end
end
