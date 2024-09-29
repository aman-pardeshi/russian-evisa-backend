# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::User::Operation::Index, type: :operation do
  context 'Users operations' do
    let!(:user) { create(:user,  role: 'admin') }
    let!(:user2) { create(:user,  name: 'xyz mpon', role: 'moderator') }

    it 'is users get loaded successfully' do
      result = described_class.call(current_user: user, params: ActionController::Parameters.new({page: 1, limit: 10}))
      expect(result.success?).to be_truthy
      expect(result[:users]).to be_present
    end

    it 'is users search successfully' do
      result = described_class.call(current_user: user, params: ActionController::Parameters.new({page: 1, limit: 10, query: 'xy'}))
      expect(result.success?).to be_truthy
      expect(result[:users]).to be_present
      expect(result[:users][0].name).to eq('xyz mpon')
    end

    it 'users are not getting listed for other role' do
      user.update(role: nil)
      result = described_class.call(current_user: user,  params: ActionController::Parameters.new({page: 1, limit: 10}))
      expect(result.failure?).to be_truthy
      expect(result[:users]).to_not be_present
    end
  end
end
