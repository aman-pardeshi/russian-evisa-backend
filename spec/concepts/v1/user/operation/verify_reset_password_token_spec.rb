require 'rails_helper'

RSpec.describe V1::User::Operation::VerifyResetPasswordToken, type: :operation   do
  context 'Verify Reset Password Token' do
    let!(:user) { create(:user) }
    let(:reset_password_token_string) do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.update(reset_password_token: enc)
      raw
    end

    it 'is reset password token validate successfully' do
      result = described_class.call(params: ActionController::Parameters.new({reset_password_token: reset_password_token_string}))
      expect(result.success?).to be_truthy
    end
    
    it 'is invalid reset_password token' do
      result = described_class.call(params: ActionController::Parameters.new({reset_password_token: "sdfghjk"}))
      expect(result.failure?).to be_truthy
    end
  end
end
