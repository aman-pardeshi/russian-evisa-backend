require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Audio Reviews' do
  let!(:user) { create(:user, role: 'admin') }
  let!(:country) { create(:country) }
  let!(:job_title) { create(:job_title) }
  let!(:event) {
    create(:event, created_by_id: user.id,
      job_title_id: job_title.id, country_id: country.id,
      owner_id: user.id, status: 'approved',
      start_date: DateTime.current + 1.day,
      brand_url: 'event1-testing'
    )
  }
  let!(:review) { create(:review, event_id: event.id, reviewer_type: 'User', reviewer_id: user.id) }
  let!(:audio_review) { create(:audio_review, audio: "audio_file_url", event_id: event.id, review_id: review.id, status: false)}

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
  end

  post '/audio_reviews' do
    parameter :audio, 'Audio file', required: true
    parameter :event_id, 'Event Id', required: true
    parameter :review_id, 'Review_id', required: true

    let!(:audio) { "audio-file-url" }
    let!(:event_id) { event.id }
    let!(:review_id) { review.id }

    example 'Create Audio review' do
      explanation 'Create Audio review'
      do_request
      expect(status).to eq(200)
    end
  end

  put '/audio_reviews' do
    parameter :audio_review_id, 'Audio Review id', required: true
    parameter :event_id, 'Event Id', required: true
    parameter :review_id, 'Review_id', required: true
    parameter :audio_status, 'Audio Status', required: true

    let!(:audio_review_id) { audio_review.id }
    let!(:event_id) { event.id }
    let!(:review_id) { review.id }
    let!(:audio_status) { 'approved'}

    example 'Create Audio review' do
      explanation 'Update Audio review'
      do_request
      expect(status).to eq(200)
    end
  end

end
