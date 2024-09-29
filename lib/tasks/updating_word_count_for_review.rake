namespace "updating_word_count_for_review" do
  desc "update_review_word_count"
  task :update_review_word_count => :environment do

    reviews = Review.all
    question_array = [1, 2, 3, 5]
    
    reviews.each do |review| 
      answers = review.review_submissions.where(question_id: question_array).pluck("answer").join()

      review.update(word_count: answers.length)
    end

    puts "word count has been calculated for all reviews"

    events = Event.all

    events.each do |event|
      overall_count = event.reviews.approved.pluck("word_count")

      if overall_count.present? 
        avg_word_count_review = overall_count.sum / event.total_review
        event.update(review_word_count: avg_word_count_review)
      end
    end

    puts "word count has been calculated for all events"
  end
end