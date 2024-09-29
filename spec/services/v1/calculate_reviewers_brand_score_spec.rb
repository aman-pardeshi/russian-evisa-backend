require 'rails_helper'

RSpec.describe V1::CalculateReviewersBrandScore, type: :model do
  describe '#total_reviewers_score' do
    let!(:user1) { create(:user, email: 'testing@gmail.com', role: 'admin') }
    let!(:reviewer) { create(:user, email: 'reviewer@gmail.com', role: 'organizer') }
    let!(:country) { create(:country) }
    let!(:job_title) { create(:job_title) }
    let!(:event1) do
      create(:event, status: 1, created_by_id: user1.id,
        job_title_id: job_title.id, country_id: country.id,
        owner_id: user1.id, start_date: DateTime.current - 2.day,
        end_date: DateTime.current, brand_url: "testing-event")
    end
    let!(:event2) do
      create(:event, status: 1, created_by_id: user1.id,
        job_title_id: job_title.id, country_id: country.id,
        owner_id: user1.id, start_date: DateTime.current - 2.day,
        end_date: DateTime.current, brand_url: "")
    end
    let!(:event3) do
      create(:event, status: 1, created_by_id: user1.id,
        job_title_id: job_title.id, country_id: country.id,
        owner_id: user1.id, start_date: DateTime.current - 2.day,
        end_date: DateTime.current, brand_url: "single-testing-event", parent_id: nil, is_yearly_event: true,
        total_review: 1, eventible_score: 3.2)
    end
    let!(:event4) do
      create(:event, status: 1, created_by_id: user1.id,
        job_title_id: job_title.id, country_id: country.id,
        owner_id: user1.id, start_date: DateTime.current + 30.day,
        end_date: DateTime.current + 28.day, brand_url: "single-testing-event", parent_id: event3.id, total_review: 1,
        eventible_score: 3.2)
    end
    let!(:review) { create(:review, status: 1, event_id: event4.id, reviewer_type: 'User', reviewer_id: reviewer.id, attended_as: "speaker") }
    let!(:review1) { create(:review, status: 1, event_id: event3.id, reviewer_type: 'User', reviewer_id: reviewer.id, attended_as: "attendee") }
    #initial role wise score is 0.0 as no reviews are added. review is from attendee for event4 whereas review1 from speaker for event3

    it 'calculate reviewers_brand score' do
      attendee_brand_score = V1::CalculateReviewersBrandScore.new(event4, 'attendee').total_reviewers_score
      speaker_brand_score = V1::CalculateReviewersBrandScore.new(event4, 'speaker').total_reviewers_score
      sponsor_brand_score = V1::CalculateReviewersBrandScore.new(event4, 'sponsor').total_reviewers_score
      expect(attendee_brand_score).to be == 0.0
      expect(speaker_brand_score).to be == 0.0
      expect(sponsor_brand_score.to_f.nan?).to be_truthy
    end

    it 'failed to role wise brand score for no event present' do
      attendee_brand_score = V1::CalculateReviewersBrandScore.new(event2, 'attendee').total_reviewers_score
      speaker_brand_score = V1::CalculateReviewersBrandScore.new(event2, 'speaker').total_reviewers_score
      sponsor_brand_score = V1::CalculateReviewersBrandScore.new(event2, 'sponsor').total_reviewers_score
      expect(attendee_brand_score.to_f.nan?).to be_truthy
      expect(speaker_brand_score.to_f.nan?).to be_truthy
      expect(sponsor_brand_score.to_f.nan?).to be_truthy
    end

    it 'failed to role wise brand score for Event with no Edition' do
      attendee_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'attendee').total_reviewers_score
      speaker_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'speaker').total_reviewers_score
      sponsor_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'sponsor').total_reviewers_score
      expect(attendee_brand_score.to_f.nan?).to be_truthy
      expect(speaker_brand_score.to_f.nan?).to be_truthy
      expect(sponsor_brand_score.to_f.nan?).to be_truthy
    end

    it 'failed to role wise brand score for single yearly event' do
      attendee_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'attendee').total_reviewers_score
      speaker_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'speaker').total_reviewers_score
      sponsor_brand_score = V1::CalculateReviewersBrandScore.new(event3, 'sponsor').total_reviewers_score
      expect(attendee_brand_score.to_f.nan?).to be_truthy
      expect(speaker_brand_score.to_f.nan?).to be_truthy
      expect(sponsor_brand_score.to_f.nan?).to be_truthy
    end
  end
end
