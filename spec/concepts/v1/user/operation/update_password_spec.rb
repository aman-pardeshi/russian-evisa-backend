require 'rails_helper'

RSpec.describe V1::User::Operation::UpdatePassword, type: :operation   do
  context 'Verify old password and update password' do
    let!(:user) { create(:user, password: 'welcome') }

    it 'is old password matched and new password updated successfully' do
      result =
        described_class.
        call(
          current_user: user,
          params:
            ActionController::Parameters.new(
            {
              old_password: 'welcome',
              password: 'welcome1',
              password_confirmation: 'welcome1'
            }
          ),
        )
      expect(result.success?).to be_truthy
    end
    
    it 'is old password doesnt matched ' do
      result =
        described_class.
        call(
          current_user: user,
          params:
            ActionController::Parameters.new(
            {
              old_password: 'welcome12',
              password: 'welcome1',
              password_confirmation: 'welcome1'
            }
          ),
        )
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
    end

    it 'is password_confirmation doesnt matched with password ' do
      result =
        described_class.
        call(
          current_user:user,
          params:
            ActionController::Parameters.new(
            {
              old_password: 'welcome',
              password: 'welcome1',
              password_confirmation: 'welcome12'
            }
          ),
        )
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
    end
  end
end
