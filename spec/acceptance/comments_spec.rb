require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Comments' do
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
  let!(:comment) { create(:comment, user_id: user.id, review_id: review.id, status: "pending", description: "Sample comment")}

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
  end

  post '/comments' do
    parameter :status, 'comment status', required: true
    parameter :user_id, 'User Id', required: true
    parameter :review_id, 'Review_id', required: true
    parameter :description, 'comment description', required: true

    let!(:user_id) { user.id }
    let!(:review_id) { review.id }
    let!(:status) { "pending" }
    let!(:description) { "Sample Comment" }

    example 'Create Organizer Comment' do
      explanation 'Create Organizer Comment'
      do_request
      expect(response_status).to eq(200)
    end
  end

  put '/comments' do
    parameter :status, 'comment status', required: true
    parameter :user_id, 'User Id', required: true
    parameter :review_id, 'Review_id', required: true
    parameter :send_mail, 'Send mail', required: true
    parameter :organizer_comment_id, "Organizer comment ID", required: true

    let!(:user_id) { user.id }
    let!(:review_id) { review.id }
    let!(:status) { "approved" }
    let!(:send_mail) { true }
    let!(:organizer_comment_id) { comment.id }

    example 'Update Organizer comment' do
      explanation 'Update Organizer comment'
      do_request
      expect(response_status).to eq(200)
    end
  end

end
