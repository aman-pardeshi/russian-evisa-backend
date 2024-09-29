namespace "learn_score_existing_events" do
    desc "calculate_and_update_learning_score"
    task :calculate_and_update_learning_score => :environment do
      @event = Event.approved.where.not(id: nil)
      @event.where.not(id: 0).each do |event|
        learning_score = event.reviews.approved.map do |review|
            review.review_submissions.where(question_id: 12).pluck(:scale)
          end
        learning_score = learning_score == 0 ? [] : learning_score.sum
        learning_score_average = learning_score == 0 ? 0.0 : learning_score.compact.inject{ |sum, el| sum + el }.to_f / learning_score.size
        event.update(learning_score: ("%.2f"% learning_score_average))
      end
      puts "Learning Score Calculated And Updated In Database"
    end
  end
  