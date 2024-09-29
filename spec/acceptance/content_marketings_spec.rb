require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'ContentMarketings' do
  let!(:user) { create(:user, role:'organizer') }
  let!(:content_marketing) { create(:content_marketing, created_by: user) }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
  end

  context "Create Content Marketing Request" do
    context "Create" do
      post "/content_marketings" do
        parameter :is_open_for_ideas_discussion,
          "We would love for Eventible's Managing Editor to interview our speakers via email?",
          type: :boolean
        parameter :is_allowed_to_interview,
          "We would love for Eventible's Managing Editor to interview our speakers via email?",
          type: :boolean
        parameter :is_allowed_to_publish_article,
          "We are happy to contribute articles to be published to Mentorifi - Eventible's blog",
          type: :boolean
        parameter :is_allowed_to_video_interview,
          "We would love for Eventible's Managing Editor to conduct video interviews with our speakers?",
          type: :boolean

        let!(:is_allowed_to_video_interview) { true }
        let!(:is_allowed_to_interview) { true }
        let!(:is_allowed_to_publish_article) { true }
        let!(:is_open_for_ideas_discussion) { true }
        let!(:raw_post) { params.to_json }
        example "Create Content Marketing Request" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  context "Update" do
    context "Update Content Marketing Request" do
      put "/content_marketings" do
        parameter :id, "Content Marketing Request id", type: :integer
        parameter :is_open_for_ideas_discussion,
        "We would love for Eventible's Managing Editor to interview our speakers via email?",
        type: :boolean
        parameter :is_allowed_to_interview,
          "We would love for Eventible's Managing Editor to interview our speakers via email?",
          type: :boolean
        parameter :is_allowed_to_publish_article,
          "We are happy to contribute articles to be published to Mentorifi - Eventible's blog",
          type: :boolean
        parameter :is_allowed_to_video_interview,
          "We would love for Eventible's Managing Editor to conduct video interviews with our speakers?",
          type: :boolean
        
        let!(:id) { content_marketing.id }
        let!(:is_allowed_to_video_interview) { true }
        let!(:is_allowed_to_interview) { true }
        let!(:is_allowed_to_publish_article) { true }
        let!(:is_open_for_ideas_discussion) { true }
        let!(:raw_post) { params.to_json }

        example "Update Content Marketing Request" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end

  context "Get Organizer Content Marketing hub Request" do
    get "/users/content_marketing_request" do
      example "Get Organizer Content Marketing Details" do
        do_request
        expect(status).to eq(200)
      end
    end
  end
end