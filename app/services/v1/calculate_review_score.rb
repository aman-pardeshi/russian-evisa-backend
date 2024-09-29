class V1::CalculateReviewScore

  def initialize(review)
    @review = review
  end

  def calculate
    overall_score =
      @review.review_submissions.recommend_question.first.scale +
      attended_as_average +
      mode_of_attendance_average
    divide_by = 3
    divide_by -= 1 if attended_as_average <= 0.0
    divide_by -= 1 if mode_of_attendance_average <= 0.0
    personal_score = (overall_score/divide_by)
    weight = calculate_upwote_downwote
    [personal_score, weight]
  end

  def attended_as_average
    sub_questions = Question.rating_sub_questions(@review.attended_as).first.sub_questions
    @review.review_submissions.scale_average(sub_questions.ids)
  end

  def mode_of_attendance_average
    sub_questions = Question.attendance_mode_questions(@review.mode_of_attendance).first.sub_questions
    @review.review_submissions.scale_average(sub_questions.ids)
  end

  def calculate_upwote_downwote
    like_length = @review.review_submissions.like_question.first.answer.size
    improve_length = @review.review_submissions.improve_question.first.answer.size

    total_string_length = like_length + improve_length

    weightage = 
    case total_string_length
    when 0..200 then 0.6
    when 200..349 then 1
    else 1.4
    end

    number_of_insightful = @review.user_insights.where(is_insightful: true).count

    if number_of_insightful == 1 or number_of_insightful > 1
      weightage = (weightage + 0.4).round(2)
    end

    if number_of_insightful > 1
      weightage = (weightage + (0.2 * (number_of_insightful - 1))).round(2)
    end

    weightage

    # like_length_str =
    #   case like_length
    #   when 0..29 then "<30"
    #   when 30..100 then "30..100"
    #   else "100>"
    #   end

    # case improve_length
    # when 0..29 then SCORE_LOGIC[like_length_str][0]
    # when 30..100 then SCORE_LOGIC[like_length_str][1]
    # else SCORE_LOGIC[like_length_str][2]
    # end
  end
end
