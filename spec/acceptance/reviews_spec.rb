# frozen_string_literal: true

require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Reviews' do
  let!(:country) { create(:country) }
  let!(:job_title) { create(:job_title) }
  let!(:user1) { create(:user, role: 'admin') }
  let!(:question1) { create(:question) }
  let!(:question2) { create(:question) }
  let!(:event1) { create(:event, created_by_id: user1.id, owner_id: user1.id, brand_url: "event1-testing") }
  let!(:review) { create(:review, event_id: event1.id, reviewer_type: 'User', reviewer_id: user1.id) }
  let!(:review_submission) { create(:review_submission, question_id: question1.id, review_id: review.id) }
  let!(:review1) { create(:review, event_id: event1.id, reviewer_type: 'User', reviewer_id: user1.id) }
  let!(:verification) { create(:verification, review: review1)}
  let!(:review2) { create(:review, event_id: event1.id, reviewer_type: 'User', is_saved: true, reviewer_id: user1.id) }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user1.id)
  end

  post '/reviews' do
    parameter :user_id, 'Pass user id if user login '
    parameter :user, 'Pass User Details', type: :object, items: %i[name company_name designation email]
    parameter :attended_as, 'Attended as [attendee/speaker/sponsor]', required: true
    parameter :utm_source, 'Utm source type [campaign/web]', required: true
    parameter :event_id, 'Event id', required: true
    parameter :answers, 'Pass array of object which contains questions and answers',
      type: :array, items: { type: :object, items: %i[answer question_id scale] }, required: true

    let!(:user_id) { user1.id }
    let!(:user) {{ designation: 'SE' }}
    let!(:attended_as) { 'attendee' }
    let!(:utm_source) { 'web' }
    let!(:event_id) { event1.id }
    let!(:answers) { [{ question_id: question1.id, answer: 'no' }, { question_id: question2.id, scale: 4 }] }

    let!(:raw_post) { params.to_json }

    example 'Creation of Review with login user' do
      explanation 'create Review'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/reviews' do
    parameter :create_account, 'pass true if user click on create my eventible account', type: :boolean
    parameter :user, 'Pass User Details', type: :object, items: %i[name company_name designation email]
    parameter :attended_as, 'Attended as [attendee/speaker/sponsor]', required: true
    parameter :utm_source, 'Utm source type [campaign/web]', required: true
    parameter :event_id, 'Event id', required: true
    parameter :answers, 'Pass array of object which contains questions and answers',
      type: :array, items: { type: :object, items: %i[answer question_id scale] },
      required: true

    let!(:create_account) { true }
    let!(:user) { { name: 'XYZ POR', email: 'xyz@gmail.com', company_name: 'josh', designation: 'se' } }
    let!(:attended_as) { 'attendee' }
    let!(:utm_source) { 'web' }
    let!(:event_id) { event1.id }
    let!(:answers) { [{ question_id: question1.id, answer: 'no' }, { question_id: question2.id, scale: 4 }] }

    let!(:raw_post) { params.to_json }

    example 'Creation of Review with create eventible account flag' do
      explanation 'create Review'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/reviews' do
    parameter :create_account, 'pass true if user click on create my eventible account', type: :boolean
    parameter :user, 'Pass User Details', type: :object, items: %i[name company_name designation email]
    parameter :attended_as, 'Attended as [attendee/speaker/sponsor]', required: true
    parameter :utm_source, 'Utm source type [campaign/web]', required: true
    parameter :event_id, 'Event id', required: true
    parameter :answers, 'Pass array of object which contains questions and answers', type: :array, items: { type: :object, items: %i[answer question_id scale] }, required: true

    let!(:create_account) { false }
    let!(:user) { { name: 'XYZ POR', email: 'xyz@gmail.com', company_name: 'josh', designation: 'se' } }
    let!(:attended_as) { 'attendee' }
    let!(:utm_source) { 'web' }
    let!(:event_id) { event1.id }
    let!(:answers) { [{ question_id: question1.id, answer: 'no' }, { question_id: question2.id, scale: 4 }] }
    let!(:raw_post) { params.to_json }

    example 'Creation of Review with guest user' do
      explanation 'create Review'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/reviews' do
    parameter :attended_as, 'Attended as [attendee/speaker/sponsor]', required: true
    parameter :utm_source, 'Utm source type [campaign/web]', required: true
    parameter :event_id, 'Event id', required: true

    let!(:attended_as) { 'attendee' }
    let!(:utm_source) { 'web' }
    let!(:event_id) { event1.id }
    let!(:raw_post) { params.to_json }

    example 'Review creation failed due to missing params' do
      explanation 'Failed review creation due to missing params'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  get '/reviews/:id' do
    parameter :id, "Review Id", type: :inetege, required: true
    let!(:id) { review.id }
    let!(:raw_post) { params.to_json }

    example 'Review details Successfully' do
      explanation 'Reviews details successfully for authorized user'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/reviews/:id' do
    parameter :id, "Review Id", type: :inetege, required: true
    let!(:id) { review.id }
    let!(:raw_post) { params.to_json }

    example 'Review details failed' do
      explanation 'Reviews details failed due to unauthorized user'
      user1.update(role: nil)
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  delete '/reviews/:id' do
    parameter :id, "Review Id", type: :integer, required: true
    let!(:id) { review.id }
    let!(:raw_post) { params.to_json }

    example 'Review deleted Successfully' do
      explanation 'Reviews deleted successfully by authorized user'
      do_request
      expect(status).to eq(200)
    end
  end

  delete '/reviews/:id' do
    parameter :id, "Review Id", type: :integer, required: true
    let!(:id) { review.id }
    let!(:raw_post) { params.to_json }

    example 'Review deleted Successfully' do
      user1.update(role: nil)
      explanation 'Reviews deleted failed by unauthorized user'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  put '/reviews/:id' do
    parameter :id, "Review Id", type: :integer, required: true
    parameter :is_flaged, "Pass this If review Flaged", type: :boolean
    parameter :is_saved, "Pass this If review saved", type: :boolean
    parameter :flaged_reason, "Pass Flaged reason", type: :string
    parameter :review_submissions_attributes, "Pass Review Submissions Hash",
      type: :array, items: [ type: :object, items: %i[id question_id answer scale] ],
      required: true

    let!(:id) { review.id }
    let!(:is_flaged) { true }
    let!(:is_saved) { true }
    let!(:flaged_reason) { "other" }
    let!(:review_submissions_attributes) {
      [{
        id: review_submission.id,
        question_id: question1.id,
        answer: "Changes",
        scale: 0
      }]
    }
    let!(:raw_post) { params.to_json }
    example 'Review updated successfully by authorised user' do
      explanation 'Review Updating successfully'
      do_request
      expect(status).to eq(200)
    end
  end

  get "/reviews" do
    parameter :page, "Page number for pagination", type: :integer, required: true
    parameter :limit, "Limit Per Page", type: :integer, required: true
    parameter :query, "search term", type: :string, optional: true

    let!(:page) { 1 }
    let!(:limit) { 10 }

    let!(:raw_post) { params.to_json }
    example "Review Listing on admin side" do
      explanation "Review Listing with pagination"
      do_request
      expect(status).to eq(200)
    end
  end

  context "Review Verification" do
    context "Update Verification" do
      put '/reviews/:review_id/verifications/:id' do
        parameter :review_id, "Review Id", type: :integer, required: true
        parameter :id, "Verification Id", type: :integer, required: true
        parameter :exists_on_outreach_db, "Exists on outreach database",
          type: :boolean
        parameter :valid_linkedin_profile,
          "Has a valid linkedin profile with 50 connections", type: :boolean
        parameter :not_competitor_or_representative,
          "Is not a competitor representative of event organizer", type: :boolean
        parameter :not_violent_lang,
          "Does not contain inappropriate language hateful speech", type: :boolean
        parameter :not_duplicate_review,
          "Not A duplicate or plagiarized review", type: :boolean
        parameter :gc_amount_approved, "Gc Amount Approved", type: :boolean
        parameter :gc_amount, "GC Amount Text", type: :string
        parameter :add_on_incentive, "Add on incentive", type: :boolean
        parameter :incentive_value, "Add on incentive text", type: :string
        parameter :on_hold, "On hold", type: :boolean
        parameter :on_hold_reason, "On hold Text", type: :string

        let!(:review_id) { review1.id }
        let!(:id) { verification.id }
        let!(:exists_on_outreach_db) { true }
        let!(:valid_linkedin_profile) { true }
        let!(:not_competitor_or_representative) { true }
        let!(:not_violent_lang) { false }
        let!(:not_duplicate_review) { false }
        let!(:gc_amount_approved) { true }
        let!(:gc_amount) { '10' }
        let!(:add_on_incentive) { true}
        let!(:incentive_value) { '50' }
        let!(:on_hold) { true }
        let!(:on_hold_reason) { "On Hold" }
        let!(:raw_post) { params.to_json }
        example "Update Verification for review" do
          explanation "updating checklist for review"
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  context "Saved Reviews" do
    context "Get. Saved reviews" do
      get "/reviews/saved_reviews" do
        parameter :page, "Send page number for pagination", type: :integer
        parameter :limit, "Send Limit for pagination", type: :integer
        parameter :query, "send query parameter", type: :integer

        let!(:page) { 1 }
        let!(:limit) { 10 }
        let!(:raw_post) { params.to_json }
        example "List The Saved Reviews" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
