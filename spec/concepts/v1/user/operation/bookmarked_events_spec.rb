# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::User::Operation::BookmarkedEvents, type: :operation do
  context 'Users operations' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, status: 'approved', created_by: user, owner: user) }
    let!(:campaign_link) { create(:campaign_link, event_id: event.id) }
    let!(:review) { create(:review, campaign_link_id: campaign_link.id, reviewer: user, event_id: event.id)}
    let!(:user_insight) { create(:user_insight, resource: event, is_bookmarked: true, user: user)}
  
    it 'is users bookmarked events get loaded successfully' do
      result = 
        described_class.
        call(
          current_user: user,
          params: ActionController::Parameters.new({page: 1, limit: 10})
        )
      expect(result.success?).to be_truthy
      expect(result[:bookmarked_events][0].id).to eq(event.id)
    end
  end
end
