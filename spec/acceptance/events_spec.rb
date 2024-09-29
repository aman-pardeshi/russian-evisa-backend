require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Events' do
  let!(:user1) { create(:user, role: 'admin') }
  let!(:country) { create(:country) }
  let!(:job_title) { create(:job_title) }
  let!(:event1) do
    create(
      :event, created_by_id: user1.id, job_title_id: job_title.id,
      country_id: country.id, owner_id: user1.id, brand_url: "event1-testing",
      total_review: 1, parent_id: nil
    )
  end
  let!(:event2) do
    create(
      :event, status: 'approved', created_by_id: user1.id,
      job_title_id: job_title.id, owner_id: user1.id,
      start_date: DateTime.current + 2.day,
      end_date:DateTime.current + 5.day,
      brand_url: "event1-testing", total_review: 2, parent_id: event1.id
    )
  end
  let!(:event3) do
    create(
      :event, status: 'approved', created_by_id: user1.id,
      job_title_id: job_title.id, owner_id: user1.id,
      start_date: DateTime.current + 10.day,
      end_date: DateTime.current + 20.day,
      brand_url: "event3-testing"
    )
  end
  let!(:event4) do
    create(
      :event, status: 'approved', created_by_id: user1.id,
      job_title_id: job_title.id, owner_id: user1.id,
      start_date: DateTime.current + 12.day,
      end_date: DateTime.current + 25.day,
      brand_url: "event4-testing"
    )
  end

  let!(:event5) do
    create(
      :event, status: 'approved', created_by_id: user1.id,
      job_title_id: job_title.id, owner_id: user1.id,
      start_date: DateTime.current + 12.day,
      end_date: DateTime.current + 25.day,
      parent_id: event4.id, brand_url: "event5-testing"
    )
  end

  let!(:event5) do
    create(
      :event, status: 'approved', created_by_id: user1.id,
      job_title_id: job_title.id, owner_id: user1.id,
      start_date: DateTime.current + 12.day,
      end_date: DateTime.current + 25.day,
      parent_id: event4.id, brand_url: "event5-testing"
    )
  end
  let!(:review) { create(:review, event_id: event1.id, reviewer_type: 'User', reviewer_id: reviewer.id) }
  let!(:review1) { create(:review, event_id: event2.id, reviewer_type: 'User', reviewer_id: reviewer.id) }

  let!(:campaign_link) do
    V1::Event::Operation::GenerateCampaignLink.
    (
      params: ActionController::Parameters.new(
        id: event1.id,
        expiry_date: Date.current,
        reward_amount: 20
      ),
      current_user: user1
    )
  end
  let!(:coupon) { create(:coupon, event_id: event1.id)}
  let!(:question1) { create(:question) }
  let!(:question2) { create(:question) }
  let!(:event1) { create(:event, created_by_id: user1.id, owner_id: user1.id, brand_url: "event1-testing") }
  let!(:review) do
    create(
      :review, status: 'approved', event_id: event3.id,
      reviewer_type: 'User', reviewer_id: user1.id,
      attended_as: 'attendee'
    )
  end
  let!(:review_submission) do
    create(
      :review_submission, question_id: question1.id,
      review_id: review.id,
      scale: 4
    )
  end

  let!(:review1) do
    create(
      :review, status: 'approved', event_id: event3.id,
      reviewer_type: 'User', reviewer_id: user1.id,
      attended_as: 'attendee'
    )
  end
  let!(:review_submission1) do
    create(
      :review_submission, question_id: question1.id,
      review_id: review1.id,
      scale: 4
    )
  end

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user1.id)
  end

  post '/events' do
    parameter :title, 'Event Title',
      required: true, scope: :event
    parameter :url_name, 'Url Name',
      required: true, scope: :event
    parameter :event_type, 'Event Type (virtual,in_person,hybrid)',
      required: true, scope: :event
    parameter :discription, 'Event Description',
      required: true, scope: :event
    parameter :brand_url, 'Event Brand URL',
      required: true, scope: :event
    parameter :price, 'Event Cost send 0 if event is free',
      required: true, scope: :event
    parameter :discount_percentage, 'Discount Percentage', scope: :event
    parameter :start_date, 'Event Start Date', scope: :event
    parameter :end_date, 'Event End Date', scope: :event
    parameter :agenda_file_url, 'Event Agenda File URL', scope: :event
    parameter :parent_id, 'if it is Parent Event Id', scope: :event
    parameter :job_title_id, 'Event Catergory Id',
      scope: :event, required: true
    parameter :country_id, 'Country ID', scope: :event, required: true
    parameter :edition, 'Edition Name', scope: :event
    parameter :is_paid, "Pass This Parameter true if event is paid", scope: :event, required: true
    parameter :coupons_attributes, "Pass Coupons array of hash", scope: :event, type: :array,
      items: { type: :object, items: %i[ name, description registration_url validity discount_percentage] }

    let!(:title) { 'Summit 2020' }
    let!(:url_name) { 'Summit20' }
    let!(:event_type) { 'in_person' }
    let!(:discription) { 'Event Description' }
    let!(:brand_url) { 'Event Brand Url' }
    let!(:price) { 20 }
    let!(:discount_percentage) { 40 }
    let!(:agenda_file_url) { 'agenda_file_url' }
    let!(:start_date) { DateTime.current.strftime("%Y-%m-%d %H:%M") }
    let!(:end_date) { (DateTime.current + 1.day).strftime("%Y-%m-%d %H:%M") }
    let!(:job_title_id) { job_title.id }
    let!(:country_id) { country.id }
    let!(:edition) { "2020" }
    let!(:is_paid) { true }
    let!(:coupons_attributes) do
      [{
        name: "Silver Pass",
        discount_percentage: 20,
        registration_url: "https:/register.me",
        validity: DateTime.current,
        description: "hello"
      },
      {
        name: "Gold Pass",
        discount_percentage: 50,
        registration_url: "https:/register.me",
        validity: DateTime.current,
        description: "hello"
      },
      {
        name: "Platinum Pass",
        discount_percentage: 80,
        registration_url: "https:/register.me",
        validity: DateTime.current,
        description: "hello"
      }]
    end
    let!(:raw_post) { params.to_json }

    example 'Create Event' do
      explanation 'Create Event'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/filters' do
    example 'Event Filter' do
      explanation 'Get All Event filters'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events' do
    parameter :page, "Page number for pagination", type: :integer, required: true
    parameter :limit, "limit for per page", type: :integer, required: true
    parameter :query, "Serach query string", type: :string, optional: true

    let!(:page) { 1 }
    let!(:limit) { 10 }
    let!(:raw_post) { params.to_json }
    example 'Event Listing' do
      explanation 'Get All Event created by Venodor/Admin'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/:id' do
    parameter :id, 'Event Id', required: true
    let!(:id) { event1.id }
    example 'Event Details' do
      explanation 'Get All Details of event'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/:id' do
    parameter :id, 'Event Id', required: true
    let!(:id) { 1 }
    example 'Event Not Found' do
      explanation 'If Event Not Found'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  put '/events/:id' do
    parameter :id, 'Event Id', required: true
    parameter :description, scope: :event
    parameter :start_date, scope: :event
    parameter :end_date, scope: :event
    let!(:id) { event1.id }
    let!(:start_date) { DateTime.current.strftime("%Y-%m-%d %H:%M") }
    let!(:end_date) { DateTime.current.strftime("%Y-%m-%d %H:%M") }
    let!(:description) { 'Updating Description' }
    let!(:raw_post) { params.to_json }
    example 'Update event' do
      explanation 'update Event discription and start date'
      do_request
      expect(status).to eq(200)
    end
  end

  delete '/events/:id' do
    parameter :id, 'Event Id', required: true
    let!(:id) { event1.id }
    let!(:raw_post) { params.to_json }
    example 'Delete event' do
      explanation 'Delete Event'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/upcoming'do
    parameter :event_type, 'send Event Type', type: :integer
    parameter :country_id, 'send country id', type: :integer
    parameter :job_title_id, 'send job_title_id', type: :integer
    parameter :time_frame, 'send time_frame in [start_date,end_date]', type: :string
    parameter :page, "Send Page Number for pagination", type: :integer
    parameter :limit, "Send Limit For Pagination", type: :integer

    let!(:event_type) { event2.event_type }
    let!(:country_id) { event2.country_id }
    let!(:job_title_id) { event2.job_title_id }
    let!(:page) { 1 }
    let!(:limit) { 2 }
    let!(:raw_post) { params.to_json }

    example 'Discover Upcoming Event With Filter' do
      explanation 'Discover Upcoming Event Eith Filters like, time frame, event_type, job_role, country'
      do_request
      expect(status).to eq(200)
    end
  end

  context 'autocomplete' do

    parameter :query, 'Event query parameter', required: true

    context 'autocomplete if query is present' do
      let(:query) { event1.title.first(3) }
      get '/events/autocomplete' do
        example 'Autocomplete Search if query is present' do
          explanation 'Events autocomplete search api'
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context 'autocomplete if query is blank' do
      get '/events/autocomplete' do
        example 'Autocomplete Search if query is missing' do
          explanation 'Events autocomplete search api'
          do_request
          expect(status).to eq(422)
        end
      end
    end
  end
  post '/events/generate_campaign_link' do
    parameter :id, "Send event id", type: :integer, required: true
    parameter :expiry_date, "send expiry date for coupon code", type: :string, required: true
    parameter :reward_amount, "Send Reward amount", type: :integer, required: true

    let!(:id) { event1.id }
    let!(:expiry_date) { Date.current }
    let!(:reward_amount) { 10 }
    let!(:raw_post) { params.to_json }

    example 'Generate the Campaign Link for event' do
      explanation 'Create Campaign Link for event'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/validate_campaign_link' do
    parameter :link, "Send event link", type: :string, required: true
    let!(:link) { CampaignLink.first.link }
    let!(:raw_post) { params.to_json }
    example 'validate Campaign Link for review' do
      explanation 'validate Campaign Link for review'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/validate_campaign_link' do
    parameter :id, "Send event id", type: :integer, required: true
    let!(:id) { CampaignLink.first.id }
    let!(:raw_post) { params.to_json }
    example 'if Campaign Link for review is Invalid or expired' do
      explanation 'if Campaign Link for review is Invalid or expired'
      CampaignLink.update(expiry_date: Date.current - 1.day)
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  context 'Delete Coupons' do
    parameter :id, 'Event id', required: true
    parameter :start_date, 'Event Start Date', required: true
    parameter :end_date, 'Event End Date', required: true
    parameter :coupons_attributes, "Coupons attributes ", type: :array, items: { type: :object, items: %i[id _destroy]}

    context 'delete Coupons if _destroy flag is 1' do
      let(:id) { event1.id }
      let(:start_date) { DateTime.current.strftime("%Y-%m-%d %H:%M") }
      let(:end_date) { DateTime.current.strftime("%Y-%m-%d %H:%M") }
      let!(:coupons_attributes) do
        [{
          id: coupon.id,
          _destroy: 1
        }]
      end
      let!(:raw_post) { params.to_json }
      put '/events/:id' do
        example 'Delete Coupons' do
          explanation 'Delete Coupons API'
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  get '/events/top_rated'do
    parameter :job_title_id, 'send Job title Id', type: :integer
    parameter :sort_by, 'pass sort_by [total_review/popular_score]', type: :string
    parameter :page, "Send Page Number for pagination", type: :integer
    parameter :limit, "Send Limit For Pagination", type: :integer

    let!(:sort_by) { 'total_review' }
    let!(:job_title_id) { event2.job_title_id }
    let!(:page) { 1 }
    let!(:limit) { 2 }
    let!(:raw_post) { params.to_json }

    example 'Discover Top Rated Event With Filter' do
      explanation 'Discover Top Rated Event Eith Filters like, job_role'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/:id/reviews' do
    parameter :id, "Send event Id", type: :integer, required: true
    parameter :attedend_as,
      "dont send if you want all reviews and" \
      "send attendee/speaker/sponsor for specific reviews", type: :string
    parameter :page, "Send Page number for pagination", type: :integer
    parameter :limit, "send limit for per page", type: :integer

    let!(:id) { event1.id }
    let!(:page) { 1 }
    let!(:limit) { 10 }
    let!(:raw_post) { params.to_json }

    example "Get Review for specific event for all" do
      explanation "Get Reviews for all"
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/:id/reviews' do
    parameter :id, "Send event Id", type: :integer, required: true
    parameter :attedend_as,
      "dont send if you want all reviews and" \
      "send attendee/speaker/sponsor for specific reviews", type: :string
    parameter :page, "Send Page number for pagination", type: :integer
    parameter :limit, "send limit for per page", type: :integer

    let!(:id) { event1.id }
    let!(:attended_as) { 'attendee' }
    let!(:page) { 1 }
    let!(:limit) { 10 }
    let!(:raw_post) { params.to_json }

    example "Get Review for specific event for specific attendee mode" do
      explanation "Get Reviews for specific attendee mode"
      do_request
      expect(status).to eq(200)
    end
  end

  get '/events/:id/similar_events' do
    parameter :id, "Send event Id", type: :integer, required: true
    parameter :page, "Send Page number for pagination", type: :integer
    parameter :limit, "send limit for per page", type: :integer

    let!(:id) { event2.id }
    let!(:page) { 1 }
    let!(:limit) { 10 }
    let!(:raw_post) { params.to_json }

    example "Get Similar Events" do
      explanation "Get Similar events api"
      do_request
      expect(status).to eq(200)
    end
  end

  post 'events/insights' do
    parameter :id, "Event Id", type: :integer
    parameter :is_bookmarked, "Pass Boolean value", type: :boolean
    parameter :is_insightful, "Pass Boolean value", type: :boolean

    let!(:id) { event1.id }
    let!(:is_insightful) { true }
    let!(:raw_post) { params.to_json }

    example 'Event mark as insightful' do
      explanation 'If user marked insightful to true'
      do_request
      expect(status).to eq(200)
    end
  end

  context 'events bulk upload' do
    parameter :file, 'events csv file for upload', type: :CSV, required: true

    context 'events invalid file' do
      let!(:events_csv) {
        CSV.open('events.csv', 'w' ) do |csv|
          csv << ['title', 'start_date']
          csv << [ 'Test E', Date.today]
        end
      }

      let(:raw_post) { {  file: Rack::Test::UploadedFile.new('events.csv', "text/png") } }

      post 'events/bulk_upload' do
        example 'Events Upload - Invalid CSV file' do
          explanation 'If upload file is not a csv or file parameter is missing'
          do_request
          expect(status).to eq(422)
          File.delete(events_csv.path)
        end
      end
    end

    context 'invalid events csv headers' do
      let!(:events_csv) {
        CSV.open('events.csv', 'w' ) do |csv|
          csv << ['title', 'start_date']
          csv << [ 'Test E', Date.today]
        end
      }

      let(:raw_post) { {  file: Rack::Test::UploadedFile.new('events.csv', "text/csv") } }

      post 'events/bulk_upload' do
        example 'Events Upload - Invalid CSV headers' do
          explanation 'If upload file has invalid csv header'
          do_request
          expect(status).to eq(422)
          File.delete(events_csv.path)
        end
      end
    end

    context 'valid csv file' do
      before do
        stub_request(:get, "https://martechconf.com/wp-content/themes/martech/img/logo-navbar-brand.png").
          to_return(status: 200, body: "", headers: {})
      end

      let(:raw_post) { {  file: Rack::Test::UploadedFile.new("#{Rails.root}/public/sample_event.csv", "text/csv") } }

      context "invalid data" do
        post 'events/bulk_upload' do
          example 'Events Upload - Valid CSV file with invalid data', document: false do
            explanation 'If upload file has valid csv header and data'
            do_request
            Country.destroy_all
            response = JSON.parse(response_body)
            expect(response['message']).to eq("Invalid csv headers, Please refer sample file")
            expect(status).to eq(422)
          end
        end
      end

      context "valid data" do
        post 'events/bulk_upload' do

          let!(:country) { create(:country, name: 'United States') }

          example 'Events Upload - Valid CSV file with valid data' do
            explanation 'If upload file has valid csv header and data'
            do_request
            response = JSON.parse(response_body)
            expect(response['message']).to eq("Invalid csv headers, Please refer sample file")
            expect(Event.where(country_id: country.id).count).to eq(0)
            expect(status).to eq(422)
          end
        end
      end
    end
  end

  context "Unclaimed Requests" do
    let!(:claim_request) { create(:claim_request, event: event1) }
    let!(:claim_request1) { create(:claim_request, event: event2) }
    context 'List the all unclaimed events' do
      get "events/unclaimed_events" do
        example "List all unclaimed events to organizer" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
