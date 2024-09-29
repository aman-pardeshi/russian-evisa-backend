require 'rails_helper'

RSpec.describe V1::CalculateBrandScore, type: :model do
  describe '#total_brand_score' do
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
        total_review: 2, eventible_score: 3.2)
    end
    let!(:event4) do
      create(:event, status: 1, created_by_id: user1.id,
        job_title_id: job_title.id, country_id: country.id,
        owner_id: user1.id, start_date: DateTime.current + 30.day,
        end_date: DateTime.current + 28.day, brand_url: "single-testing-event", parent_id: event3.id, total_review: 1,
        eventible_score: 3.2)
    end
    let!(:review) { create(:review, event_id: event4.id, reviewer_type: 'User', reviewer_id: reviewer.id) }
    let!(:review1) { create(:review, event_id: event2.id, reviewer_type: 'User', reviewer_id: reviewer.id) }
    let!(:review2) { create(:review, event_id: event3.id, reviewer_type: 'User', reviewer_id: reviewer.id) }

    #Event4 is the edition of Event3. The review is for Event4. The brand score for this event is 3.20
    it 'calculate brand score for rolling 12 months event' do
      score = V1::CalculateBrandScore.new(review).total_brand_score
      expect(("%.2f"% score)).to be == "3.20"
    end

    it 'failed to calculate brand score for no event present' do
      score = V1::CalculateBrandScore.new(review1).total_brand_score
      expect(score.to_f.nan?).to be_truthy
    end

    it 'failed to calculate brand score for Event with no Edition' do
      score = V1::CalculateBrandScore.new(review2).total_brand_score
      expect(score.to_f.nan?).to be_truthy
    end

    it 'failed to calculate brand score for single yearly event' do
      score = V1::CalculateBrandScore.new(review2).total_brand_score
      expect(score.to_f.nan?).to be_truthy
    end
  end
end
