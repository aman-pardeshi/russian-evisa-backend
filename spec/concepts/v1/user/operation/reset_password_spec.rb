require 'rails_helper'

RSpec.describe V1::User::Operation::ResetPassword, type: :operation   do
  context 'Reset Password  user and update password' do
    let!(:user) { create(:user) }
    let(:reset_password_token_string) do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.update(reset_password_token: enc)
      raw
    end

    it 'is reset password successfully' do
      result = V1::User::Operation::ResetPassword.call(params: ActionController::Parameters.new({reset_password_token: reset_password_token_string , password: 'password', password_confirmation: 'password' }))
      expect(result.success?).to be_truthy
    end
  end
end
