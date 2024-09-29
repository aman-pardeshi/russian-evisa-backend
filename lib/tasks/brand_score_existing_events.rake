namespace "brand_score_existing_events" do
  desc "calculate_score"
  task :calculate_brand_score => :environment do
    @event = Event.approved.where.not(parent_id: nil)
    @event.where.not(parent_id: 0).each do |event|
      score = V1::CalculateBrandScore.new(nil, event)
      attendee_score  = V1::CalculateReviewersBrandScore.new(event, 'attendee')
      speaker_score  = V1::CalculateReviewersBrandScore.new(event, 'speaker')
      sponsor_score  = V1::CalculateReviewersBrandScore.new(event, 'sponsor')
      event.update_attributes(
      {
        attendee_brand_score: ("%.2f"% attendee_score.total_reviewers_score),
        speaker_brand_score: ("%.2f"% speaker_score.total_reviewers_score),
        sponsor_brand_score: ("%.2f"% sponsor_score.total_reviewers_score),
        brand_score: ("%.2f"% score.total_brand_score)
      })
    end
    puts "Event and Role Wise Brand Score Calculated"
  end
end
