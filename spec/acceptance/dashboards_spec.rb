require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Dashboards' do
  let!(:user) { create(:user, role: 'admin') }
  let!(:user1) { create(:user, role: 'organizer') }
  let!(:event) { create(:event, created_by: user, owner: user, brand_url: "event-testing")}
  let!(:event1) { create(:event,  created_by: user, owner: user, brand_url: "event1-testing")}
  let!(:review) { create(:review, event: event, reviewer: user) }
  let!(:event2) do
    create(:event,
      status: 'approved',
      created_by: user1,
      owner: user1,
      end_date: Date.current - 2.day,
      brand_url: "event2-testing"
    )
  end
  let!(:event3) do
    create(:event,
      status: 'approved',
      created_by: user1,
      owner: user1,
      end_date: Date.current - 2.day,
      brand_url: "event3-testing"
    )
  end
  let!(:review) { create(:review, event: event3, reviewer: user) }
  let!(:review) { create(:review, event: event3, reviewer: user, attended_as: 'speaker') }
  let!(:review) { create(:review, event: event2, reviewer: user, attended_as: 'sponsor') }


  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
  end

  context 'Admin' do
    context 'Get Counts With default date range' do
      get '/dashboards/admin' do
        example "Get The Dashboard Counts" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context 'Get Counts with time frame' do
      get '/dashboards/admin' do
        parameter :time_frame, "Pass date range", type: :string
        let!(:time_frame) { "#{DateTime.now - 1.day},#{DateTime.now}"}
        let!(:raw_post) { params.to_json }

        example 'Get Dash board counts by date range' do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context "Get statistics for selected event" do
      get '/dashboards/event_statistics' do
        parameter :id, "Pass Event Id", type: :integer, required: true
        let!(:id) { event1.id }
        example "List The Statistics for selected event" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  context "Organizer Dashboard APIs" do

    before do
      header 'Authorization', ApiKeyHandler.encoded_api_key(user1.id)
    end

    context "Counts with Date Range" do
      get "/dashboards/organizer" do
        parameter :time_range, "Pass Date Range", type: :string
        let!(:time_range) { "#{DateTime.now - 1.day},#{DateTime.now}"}
        example 'Get Organizer Dashboard counts' do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context 'Event Listing' do

      get "/dashboards/organizer_events" do
        example "Get Events list" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context 'Event Listing With pagination' do
      get "/dashboards/organizer_events" do
        parameter :page, "Pagination page number ", type: :integer
        parameter :limit, "pagination limit ", type: :integer
        parameter :query, "Query parameter to search event", type: :string

        let!(:page) { 1 }
        let!(:limit) { 10 }
        example "Get search Events list" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
