require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'


resource 'Hompages' do
  let!(:user1) { create(:user)}
  let!(:question1) { create(:question) }
  let!(:event1) { create(:event, status: 1, created_by_id: user1.id, owner_id: user1.id, brand_url: "event1-testing" )}
  let!(:event2) { create(:event, status: 1, created_by_id: user1.id, owner_id: user1.id, brand_url: "event2-testing", start_date: DateTime.now, end_date: DateTime.now + 2 )}
  let!(:event3) { create(:event, status: 1, created_by_id: user1.id, owner_id: user1.id, brand_url: "event2-testing", start_date: DateTime.now + 30, end_date: DateTime.now + 32 )}
  let!(:event4) { create(:event, status: 1, created_by_id: user1.id, owner_id: user1.id, brand_url: "event2-testing", start_date: DateTime.now + 60, end_date: DateTime.now + 62 )}
  let!(:review) {create(:review, status: "approved", event_id: event1.id, reviewer_type: 'User', reviewer_id: user1.id) }
  let!(:review_submission) { create(:review_submission, question: Question.find_by(title: "What did you like best about the event?"), review_id: review.id) }
  let!(:review1) {create(:review, event_id: event1.id, status: "approved", reviewer_type: 'User', reviewer_id: user1.id) }
  let!(:review_submission1) { create(:review_submission, question: Question.find_by(title: "What did you like best about the event?"), review_id: review1.id) }
  let!(:organizer_enquiry) { create(:organizer_enquiry, email: "xyz3@gmail.com")}
  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user1.id)
  end

  get '/homepages/events' do
    parameter :page, "Pass Page number", type: :integer
    parameter :limit, "Pass limit for pagination", type: :integer

    let!(:page) { 1 }
    let!(:limit) { 3 }
    let!(:raw_post) { params.to_json }

    example 'Event Listing' do
      explanation 'Get All Events'
      do_request
      expect(status).to eq(200)
    end
  end

  get 'homepages/review_just_droped' do
    parameter :page, "Pass Page number", type: :integer
    parameter :limit, "Pass limit for pagination", type: :integer

    let!(:page) { 1 }
    let!(:limit) { 3 }
    let!(:raw_post) { params.to_json }
    example 'Homepage Review just Droped Listing' do
      explanation 'Review Just Droped API'
      do_request
      expect(status).to eq(200)
    end
  end

  post 'homepages/review_insight' do
    parameter :review_id, "Review Id", type: :integer
    parameter :is_bookmarked, "Pass Boolean value", type: :boolean
    parameter :is_insightful, "Pass Boolean value", type: :boolean

    let!(:review_id) { review.id }
    let!(:is_insightful) { true }
    let!(:raw_post) { params.to_json }

    example 'Homepage Review just Droped make insightfull' do
      explanation 'If user marked insightfull to true'
      do_request
      expect(status).to eq(200)
    end
  end

  # post 'homepages/love_eventible' do
  #   parameter :name, "Review Id", type: :integer
  #   parameter :job_role, "Pass Job Role name", type: :string
  #   parameter :email, "Pass email ", type: :string

  #   let!(:name) { "XYZ PQR" }
  #   let!(:job_role) { "HR" }
  #   let!(:email) { "xyz@gmail.com" }
  #   let!(:raw_post) { params.to_json }
  #   example 'Homepage Love Eventible API' do
  #     explanation 'Homepage Love Eventible API'
  #     do_request
  #     byebug
  #     expect(status).to eq(200)
  #   end
  # end

  post 'homepages/organizer_enquiry' do
    parameter :name, "Pass Name", type: :string
    parameter :company, "Pass Company name", type: :string
    parameter :email, "Pass Email", type: :string

    let!(:name) { "PQR MNP" }
    let!(:company) { "josh" }
    let!(:email) { "xyz@gmail.com"}
    let!(:raw_post) { params.to_json }

    example 'Organizer Enquiry API' do
      explanation 'Organizer Enquiry API'
      do_request
      expect(status).to eq(200)
    end
  end

  post 'homepages/organizer_enquiry' do
    parameter :name, "Pass Name", type: :string
    parameter :company, "Pass Company name", type: :string
    parameter :email, "Pass Email", type: :string

    let!(:review_id) { "PQE CRS" }
    let!(:company) { "josh" }
    let!(:email) { "xyz3@gmail.com"}
    let!(:raw_post) { params.to_json }

    example 'If Email address is alredy present in organizer enquiry' do
      explanation 'failed to save enquiry'
      do_request
      expect(status).to eq(422)
    end
  end

  get '/homepages/event_details' do
    parameter :event_id, 'Event Id', required: true
    let!(:event_id) { event1.id }
    example 'Get Event Details on homepage' do
      explanation 'Get All Details of event'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/homepages/event_details' do
    parameter :slug, 'Slug', required: true
    let!(:slug) { event2.slug }
    example 'Get Event Details on homepage' do
      explanation 'Get All Details of event'
      do_request
      expect(status).to eq(200)
    end
  end
end
