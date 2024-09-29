require 'rails_helper'

RSpec.describe V1::User::Operation::AcceptInvitation, type: :operation   do
  context 'Reset Password  user and update password' do
    let!(:user) { create(:user) }
    let(:invitation_token_string) do
      raw, enc = Devise.token_generator.generate(User, :invitation_token)
      user.update(invitation_token: enc)
      raw
    end
    it 'is reset password successfully' do
      user.invite!(user)
      result = described_class.call(params: ActionController::Parameters.new({invitation_token: invitation_token_string, password: 'password', password_confirmation: 'password' }))
      expect(result.success?).to be_truthy
    end
    
    it 'is valid reset password token' do
      user.send_reset_password_instructions
      result = described_class.call(params: ActionController::Parameters.new({invitation_token: "sdfghjk", password: 'password', password_confirmation: 'password' }))

      expect(result.failure?).to be_truthy
    end
  end
end
