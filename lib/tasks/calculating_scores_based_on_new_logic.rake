namespace "calculating_scores_based_on_new_logic" do 
  desc "Removes extra space added by user from the start and end of the sentence"
  task :remove_extra_space_from_answers => :environment do
    reviews = Review.all.approved.order(:id)

    reviews.each do |review|
      like_answer = review.review_submissions.like_question.first.answer&.squish
      improve_answer = review.review_submissions.improve_question.first.answer&.squish
      
      review.review_submissions.like_question.first.update(answer: like_answer)
      review.review_submissions.improve_question.first.update(answer: improve_answer)
      
      puts "reviews #{review.id}"
    end
  end

  desc "calculating review weightage and eventible score based on new logic"
  task :calculate_score => :environment do
    reviews = Review.all.approved.order(:id)
    reviews.each do |review|
      obj = V1::CalculateReviewScore.new(review)
      personal_score, weight = obj.calculate
      review.update(personal_score: personal_score, weight: weight.round(2))
      puts "reviews #{review.id}"
    end

    events = Event.all.approved.order(:id)

    events.each do |event|
      event_reviews = event.reviews.approved
      sum_product = event_reviews.sum("personal_score * weight")
      sum_weight = event_reviews.sum(:weight)
      eventible_score = (sum_product == 0 || sum_weight == 0) ? 0.0 : (sum_product/sum_weight)

      if eventible_score > 0
        obj = V1::CalculateBayesianAverage.new(eventible_score, event_reviews[0])
        event.update(eventible_score: ("%.2f"% eventible_score), bayesian_average: obj.bayesian_average)
      end

      puts "events #{event.id}"
    end
  end
end