namespace "badge_update" do
  desc "calculate_and_update_all_badges"
  task :calculate_and_update_all_badges => :environment do
    @event = Event.approved.where.not(id: nil)
    @event.where.not(id: 0).each do |event|

      #For most popular badge
      event_id = event.parent_id.nil? ? event.id : event.parent_id
      event_with_editions = Event.where("parent_id = ? OR id = ?", event_id, event_id).order('start_date DESC')
      total_review_count = event_with_editions.where(event_with_editions.arel_table[:start_date].between(event.start_date - 12.months..event.start_date)).pluck(:total_review).sum

      checking_for_popular_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 3

      if total_review_count > 20 and !checking_for_popular_badge
        badge = Badge.new(event_id: event.id, badge_id: 3, badge_name: "Most Popular Badge", badge_description: "MOST Popular", year: event.end_date.year)
        badge.save!
      end

      #For Most loved badge
      attendee_score = Event.where(job_title_id: event.job_title_id).map do |e|
        e.personal_average_score('attendee').to_f
      end
      highest_attendee_score = attendee_score.max

      checking_for_loved_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 9

      if (event.personal_average_score('attendee').to_f >= highest_attendee_score and !checking_for_loved_badge and event.total_review > 5)
        badge = Badge.new(event_id: event.id, badge_id: 9, badge_name: "Most Loved Badge", badge_description: "MOST Loved", year: event.end_date.year)
        badge.save!
      end

      #For Ranked one badge
      if event.job_title_id.present?
        rank_one_event = Event.where(job_title_id: event.job_title_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first
      else
        rank_one_event = Event.where(industry_id: event.industry_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first
      end

      checking_for_ranked_one_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 4
  
      if event.id == rank_one_event.id and !checking_for_ranked_one_badge and event.total_review > 5
        badge = Badge.new(event_id: event.id, badge_id: 4, badge_name: "Ranked One Badge", badge_description: "#1 Event", year: event.end_date.year)
        badge.save!
      end

      #For Ranked Third Badge
      if event.job_title_id.present?
        ranked_third_event = Event.where(job_title_id: event.job_title_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first(3)
      else
        ranked_third_event = Event.where(industry_id: event.industry_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first(3)
      end

      checking_for_ranked_third_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 5

      if event.id == ranked_third_event.last.id and !checking_for_ranked_third_badge
        badge = Badge.new(event_id: event.id, badge_id: 5, badge_name: "Top 3 Badge", badge_description: "TOP 3", year: event.end_date.year)
        badge.save! 
      end

      #For Ranked Tenth Badge
      if event.job_title_id.present?
        ranked_third_event = Event.where(job_title_id: event.job_title_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first(10)
      else
        ranked_third_event = Event.where(industry_id: event.industry_id).sort {|a,b| a.event_score <=> b.event_score}.reverse.first(10)
      end
      checking_for_ranked_tenth_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 6

      if event.id == ranked_third_event.last.id and !checking_for_ranked_tenth_badge
        badge = Badge.new(event_id: event.id, badge_id: 6, badge_name: "Top 10 Badge", badge_description: "TOP 10", year: event.end_date.year)
        badge.save!
      end

      #For best for learning badge
      learning_score = event.reviews.map do |review|
        review.review_submissions.where(question_id: 12).pluck(:scale)
      end

       learning_score = learning_score == 0 ? [] : learning_score.sum

      learning_score_average = learning_score == 0 ? 0.0 : learning_score.compact.inject{ |sum, el| sum + el }.to_f / learning_score.size

      checking_for_learning_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 8

      if learning_score_average >= 4.5 and !checking_for_learning_badge and event.total_review > 5
        badge = Badge.new(event_id: event.id, badge_id: 8, badge_name: "Best for Learning Badge", badge_description: "BEST FOR Learning", year: event.end_date.year)
        badge.save!
      end

      # #For Networking Badge
      # networking_score = event.reviews.map do |review|
      #   review.review_submissions.where(question_id: 15).pluck(:scale)
      # end
      # networking_score_average = networking_score == 0 ? 0.0 : networking_score.compact.inject{ |sum, el| sum + el }.to_f / networking_score.size
      # checking_for_networking_badge = Badge.where(event_id: event.id).map {
      #   |badge| badge[:badge_id] }.include? 7

      # if networking_score_average >= 4.0 and !checking_for_networking_badge and event.total_review > 5
      #   badge = Badge.new(event_id: event.id, badge_id: 7, badge_name: "Best for Networking Badge", badge_description: "BEST FOR Networking", year: event.end_date.year)
      #   badge.save!
      # end

      #Most Recommended Badge
      recommended_score = event.reviews.map do |review|
        review.review_submissions.where(question_id: 4).pluck(:scale)
      end
      recommended_score = recommended_score == 0 ? [] : recommended_score.sum
      recommended_score_average = recommended_score == 0 ? 0.0 : recommended_score.compact.inject{ |sum, el| sum + el }.to_f / recommended_score.size

      checking_for_recommended_badge = Badge.where(event_id: event.id).map {
        |badge| badge[:badge_id] }.include? 10
      
      if recommended_score_average >= 4.0 and !checking_for_recommended_badge and event.total_review > 5
        badge = Badge.new(event_id: event.id, badge_id: 10, badge_name: "Most Recommended Badge", badge_description: "MOST Recommended", year: event.end_date.year)
        badge.save!
      end

    end
    puts "Badges have been calculated and updated in database"
  end
end