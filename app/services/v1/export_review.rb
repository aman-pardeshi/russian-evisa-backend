class V1::ExportReview

  TITLE_QUESTION = "Review Title - Please describe your experience in a short sentence"
  LIKE_QUESTION = "What did you like best about the event?"
  IMPROVE_QUESTION = "What could the organizers do to improve the event?"
  RECOMMENDED_QUESTION = "How likely is it that you would recommend this event to a friend or colleague?"
  SPEAKER_QUESTION = "Did you have a favourite speaker or session? Please tell us below"
  PARENT_QUESTION = "Using the scale provided, please rate the event on the following aspects:"

  def initialize(event)
    @event = event
  end

  def calculate
    total_reviews = @event.reviews.approved.map do |review|
      details = [
        @event.title,
        review.id,
        review.reviewer_name,
        review.attended_as,
        review.mode_of_attendance,
        review.reviewer.company_name,
        review.reviewer.designation,
        review.reviewer.email,
        @event.eventible_score,
        review.created_at.strftime("%d/%m/%Y")
      ]
      details = details << load_answers(review)
      details = details.flatten
    end
    total_reviews
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
    attendee_submission_favourite_speaker=
      submissions
      .where("questions.question_for = #{Question.question_fors[:attendee]}")
      .where("questions.title = '#{SPEAKER_QUESTION}'")
    submissions=
      submissions
      .where("questions.question_for = #{Question.question_fors[:common]}")
      .where("questions.title != '#{SPEAKER_QUESTION}'")
    [review_title(submissions),
      like_question_answer(submissions),
      improve_question_answer(submissions),
      recommend_question_answer(submissions),
      attendee_submission_favourite_speaker.present? ? favourite_speaker(attendee_submission_favourite_speaker) : ""
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

  def favourite_speaker(submissions)
    submissions.
    where(
      question:
        Question.find_by_title(SPEAKER_QUESTION)
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
