require 'rails_helper'

RSpec.describe V1::User::Operation::SendInvitation, type: :operation   do
  context 'Send invation to user' do
    let!(:user) { create(:user, role: 'admin', email: 'new@gmail.com')}
    let!(:user_params) {
      ActionController::Parameters.
        new(
          {
            name:'prashant bangar',
            email:'testing@gmail.com',
            role: 'moderator'
          }
        )
    }

    it 'is invitation sent to new user' do
      result = described_class.(params: user_params, current_user: user)
      expect(result.success?).to be_truthy
      expect(result[:message].present?).to be_truthy
      expect(result[:message]).to eq(
        I18n.t(
          'devise.invitations.send_instructions',
          email: user_params[:email]
        )
      )
    end

    it 'if email address is already present in db' do
      user_params[:email] = user.email
      result = described_class.(params: user_params, current_user: user)
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
      expect(result[:error]).to eq("Email has already been taken")
    end

    it 'is invitation sent by unauthorized user' do
      user.update(role: nil)
      result = described_class.(params: user_params, current_user: user)
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
      expect(result[:error]).to eq(I18n.t('errors.unauthorized_user'))
    end
  end
end
