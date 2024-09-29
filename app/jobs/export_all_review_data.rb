class ExportAllReviewData < ApplicationJob
  require 'csv'
  queue_as :default

  TITLE_QUESTION = "Review Title - Please describe your experience in a short sentence"
  LIKE_QUESTION = "What did you like best about the event?"
  IMPROVE_QUESTION = "What could the organizers do to improve the event?"
  RECOMMENDED_QUESTION = "How likely is it that you would recommend this event to a friend or colleague?"
  SPEAKER_QUESTION = "Did you have a favourite speaker or session? Please tell us below"
  PARENT_QUESTION = "Using the scale provided, please rate the event on the following aspects:"

  def perform(reviews)
    file_path = "#{Rails.root}/public/all_reviews_with_answer.csv"
    headers =
    [ "gift card amount", 
      "Review Status",
      "Event Id",
      "Event Name", 
      "Event Category", 
      "Eventible Score", 
      "Event Landing Page",
      "Audio Review",
      "Audio Review Status",
      "Country", 
      "Word Count",
      "Review Submission Date",
      "Insightful",
      "Reviewer name", 
      "attended_as",
      "mode_of_attendance", 
      "company", 
      "designation", 
      "Email",
      "Linkedin Url", 
      "Combined Length",
      "Review Overall Score",
      "Review Weight",
      "Review Title - Please describe your experience in a short sentence",
      "What did you like best about the event?", "What could the organizers do to improve the event?",
      "How likely is it that you would recommend this event to a friend or colleague?",
      "Overall experience", 
      "Value for money", 
      "Networking opportunities(attendee)",
      "Usefulness of participating vendors/sponsors", 
      "Session(s)",
      "Amount of new information learned", 
      "Overall experience(speaker)",
      "Networking opportunities(speaker)", "Technical support for setting up the session",
      "Interactivity with the audience", 
      "Quality of the audience",
      "Overall experience(sponsor)", 
      "Engagement opportunities with the audience",
      "Fit of the audience for my company", 
      "ROI on spend", 
      "Positive brand exposure",
      "Navigation of virtual platform", "Troubleshooting technical issues",
      "Event destination", 
      "Event venue", 
      "Food and beverages at event",
      "Helpfulness of event staff", 
      "Favourite speaker or session"
    ]

    CSV.open(file_path, "wb") do |csv|
      csv << headers
      reviews.each do |review|
        puts review.id

        details = [
          review.campaign_link_id.present? ? CampaignLink.find(review.campaign_link_id).reward_amount : "0",
          review.status,
          review.event.id,
          review.event.title,
          review.event.category,
          review.event.eventible_score,
          "https://eventible.com/#{review.event.category}/#{review.event.slug}",
          review.audio_review.present?,
          review.audio_review.present? ? review.audio_review.status : "",
          review.event.country.name,
          review.word_count,
          review.created_at,
          load_insightful(review), 
          review.reviewer_name,
          review.attended_as,
          review.mode_of_attendance,
          review.reviewer.company_name,
          review.reviewer.designation,
          review.reviewer.email,
          review.reviewer_type == "User" ? review.reviewer.linkedin_url : "",
          review.review_submissions.like_question.first.answer.size + review.review_submissions.improve_question.first.answer.size,
          review.personal_score,
          review.weight
        ]
        details = details << load_answers(review)
        details = details.flatten
        csv << details
      end
    end
    # system("rm -rf #{file_path}")
  end

  private

  def load_insightful(review)
    review.user_insights.pluck(:is_insightful).select {|value| value == true}.count
  end

  def load_answers(review)
    submissions = review.review_submissions.joins(:question).order(:question_id)
    answers = []

    submissions.each do |submission|
      case submission.question_id
        when 1
          answers[0] = submission.answer.gsub("\;", ".")
        when 2
          answers[1] = submission.answer.gsub("\;", ".")
        when 3
          answers[2] = submission.answer.gsub("\;", ".")
        when 4
          answers[3] = submission.answer
        when 7
          answers[4] = submission.answer
        when 8
          answers[5] = submission.answer
        when 9
          answers[6] = submission.answer
        when 10
          answers[7] = submission.answer
        when 11
          answers[8] = submission.answer
        when 12
          answers[9] = submission.answer
        when 14
          answers[10] = submission.answer
        when 15
          answers[11] = submission.answer
        when 16
          answers[12] = submission.answer
        when 17
          answers[13] = submission.answer
        when 18
          answers[14] = submission.answer
        when 20
          answers[15] = submission.answer
        when 21
          answers[16] = submission.answer
        when 22
          answers[17] = submission.answer
        when 23
          answers[18] = submission.answer
        when 24
          answers[19] = submission.answer
        when 26
          answers[20] = submission.answer
        when 27
          answers[21] = submission.answer
        when 29
          answers[22] = submission.answer
        when 30
          answers[23] = submission.answer
        when 31
          answers[24] = submission.answer
        when 32
          answers[25] = submission.answer
        when 5
          answers[26] = submission.answer.present? ? submission.answer.gsub("\;", ".") : ""
      end
    end

    answers.map{|answer| answer.nil? ? "" : answer}
  end
end