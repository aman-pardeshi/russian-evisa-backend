require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Vendor Requests' do
  let!(:vendor_request) { create(:vendor_request) }
  let!(:user) { create(:user, role: 'admin') }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
  end

  context 'Create Vendor Request' do
    parameter :name, "Vendor Name", type: :string, required: true
    parameter :email, "Vendor Email", type: :string, required: true
    parameter :designation, "Vendor JobRole", type: :string, required: true
    parameter :company_name, "Vendor company_name", type: :string, required: true
    parameter :linkedin_url, "Vendor Linkedin URL", type: :string
    parameter :twitter_handle, "Vendor Twitter Handle", type: :string
    parameter :is_event_listed, "Is event listed boolean value", type: :boolean
    parameter :user_id, "Pass this when user login using google/linkedin or if user login already", type: :integer

    context "create Vendor Request" do
      let!(:name) { "XYZ PQR"}
      let!(:email) { "xyz@gmail.com" }
      let!(:designation) { "HR" }
      let!(:company_name) { "zsert" }
      let!(:raw_post) { params.to_json }

      post "/vendor_requests" do
        example "Create Vendor Request" do
          explanation "Create vendor request "
          do_request
          expect(status).to eq(200)
        end
      end

      context "If email id is already present is system" do

        let!(:name) { "XYZ PQR"}
        let!(:email) { vendor_request.email }
        let!(:designation) { "HR" }
        let!(:company_name) { "zsert" }
        let!(:raw_post) { params.to_json }

        post "/vendor_requests" do
          example "Create Vendor Request Failed" do
            explanation "if email address is already present "
            do_request
            expect(status).to eq(ERROR_STATUS_CODE)
          end
        end
      end
    end
  end

  context 'Vendor Request Listing' do
    before do
      header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
    end

    context 'Vendor Request Listing' do
      get "/vendor_requests" do
        example "Vendor Request Listing" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  context 'Vendor Request Show' do
    before do
      header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
    end

    parameter :id, "Vendor Request ID", type: :integer, required: true

    context 'With Valid Vendor Request ID' do
      let!(:id) { vendor_request.id }
      let!(:raw_post) { params.to_json }
      get "/vendor_requests/:id" do
        example "With Valid Vendor Request id" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context 'With InValid Vendor Request ID' do
      let!(:id) { VendorRequest.last.id + 1 }
      let!(:raw_post) { params.to_json }
      get "/vendor_requests/:id" do
        example "With InValid Vendor Request id" do
          do_request
          expect(status).to eq(422)
        end
      end
    end
  end

  context 'Vendor Request Update' do
    before do
      header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
    end

    parameter :id, "Vendor Request ID", type: :integer, required: true
    # parameter :status, "pending/approved/rejected", type: :string
    parameter :linkedin_url, "Vendor Linkedin URL", type: :string
    parameter :twitter_handle, "Vendor Twitter Handle", type: :string
    parameter :is_event_listed, "Is event listed boolean value", type: :boolean

    context 'Update status With Valid Vendor Request ID' do
      let!(:id) { vendor_request.id }
      let!(:linkedin_url) { "dfghjkl" }
      let!(:raw_post) { params.to_json }

      get "/vendor_requests/:id" do
        example "Update status With valid Vendor Request id" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
