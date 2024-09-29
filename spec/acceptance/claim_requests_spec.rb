require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'


resource 'ClaimRequests' do
  let!(:user) { create(:user, role: 'admin') }
  let!(:user1) { create(:user, role: 'organizer') }

  let!(:event1) do
    create(
      :event, status: 'approved',
      created_by_id: user1.id, owner_id: user1.id, brand_url: "event1-testing"
    )
  end
  let!(:event2) do
    create(
      :event, status: 'approved',
      created_by_id: user1.id, owner_id: user1.id, brand_url: "event2-testing"
    )
  end
  let!(:claim_request) { create(:claim_request, event: event1) }
  let!(:claim_request1) { create(:claim_request, event: event2) }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
  end

  context "CRUD Claim Request" do
    context "Create Claim request" do
      post "/claim_requests" do
        parameter :event_id, "Event Id", type: :integer, required: true
        let!(:event_id) { event1.id }
        let!(:raw_post) { params.to_json }
        example "Create Claim request for unclaimed event" do
          explanation "creating claim request for unclaimed event"
          do_request
          expect(status).to eq(200)
        end
      end
    end

    # context "Update Claim request" do
    #   put "/claim_requests/:id" do
    #     parameter :id, "Claim Request Id", type: :integer, required: true
    #     parameter :status, "Send Status[reject/approved]", type: :string, required: true

    #     let!(:id) { claim_request.id }
    #     let!(:raw_post) { params.to_json }
    #     example "Update Claim request for claimed event" do
    #       explanation "updating claim request for claimed event"
    #       do_request
    #       expect(response_body[:data].present?).to eq(true)
    #     end
    #   end
    # end

    context "List Claim request" do
      get "/claim_requests" do
        parameter :page, "Page number for pagination", type: :integer
        parameter :limit, "Limit for pagination", type: :integer

        let!(:page) { 1 }
        let!(:limit) { 10 }
        let!(:raw_post) { params.to_json }

        example "Listing of Claim requests" do
          explanation "listing all claim requests claim request for unclaimed event"
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
