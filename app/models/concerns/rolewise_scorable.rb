module RolewiseScorable
  extend ActiveSupport::Concern

  def calculate_reviewers_brand_score
    klass = self.is_a?(Event) ? self : self.event
    return if klass.parent_id.nil? || klass.is_yearly_event
    attendee_score  = V1::CalculateReviewersBrandScore.new(klass, 'attendee')
    speaker_score  = V1::CalculateReviewersBrandScore.new(klass, 'speaker')
    sponsor_score  = V1::CalculateReviewersBrandScore.new(klass, 'sponsor')
    klass.update_attributes(
    {
      attendee_brand_score: ("%.2f"% attendee_score.total_reviewers_score),
      speaker_brand_score: ("%.2f"% speaker_score.total_reviewers_score),
      sponsor_brand_score: ("%.2f"% sponsor_score.total_reviewers_score)
    })
  end
end
