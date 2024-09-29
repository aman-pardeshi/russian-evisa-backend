# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::User::Operation::Deactivate, type: :operation do
  context 'Users operations' do
    let!(:user) { create(:user,  role: 'admin') }

    it 'is users get loaded successfully' do
      result = described_class.call(current_user: user)
      expect(result.success?).to be_truthy
      expect(user.inactive?).to be_truthy
    end
  end
end
