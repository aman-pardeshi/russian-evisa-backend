namespace "network_score_existing_events" do
    desc "calculate_and_update_networking_score"
    task :calculate_and_update_networking_score => :environment do
      events = Event.all.approved.order(:id)
      events.each do |event|
        networking_score = event.reviews.approved.map do |review|
            review.review_submissions.where("question_id = ? or question_id = ?", 15, 9).pluck(:scale)
          end
        networking_score = networking_score == 0 ? [] : networking_score.sum
        networking_score_average = networking_score == 0 ? 0.0 : networking_score.compact.inject{ |sum, el| sum + el }.to_f / networking_score.size
        event.update(networking_score: ("%.2f"% networking_score_average))
      end
      puts "Networking Score Calculated And Updated In Database"
    end
  end
  