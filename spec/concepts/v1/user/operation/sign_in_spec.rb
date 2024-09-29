require 'rails_helper'

RSpec.describe V1::User::Operation::SignIn, type: :operation   do
  context 'SignIn using email and password' do
    let!(:user1) { create(:user, email:'testing@gmail.com')}
    it 'Can user signIn with valid email and password' do
      V1::User::Operation::ConfirmUser.
        (params: { confirmation_token: user1.confirmation_token })
      result = V1::User::Operation::SignIn.
        (params:{email: user1.email, password: 'welcome'})
      expect(result.success?).to be_truthy
      expect(result[:user].present?).to be_truthy 
    end

    it 'Can user signIn with invalid email and password' do
      V1::User::Operation::ConfirmUser.
        (params: { confirmation_token: user1.confirmation_token })
      result = V1::User::Operation::SignIn.
        (params: {email: user1.email, password: 'welcom'})
      expect(result.failure?).to be_truthy
      expect(result[:error]).to eq(I18n.t(
        'devise.failure.not_found_in_database',
        authentication_keys: 'email'
        )
      )
    end
  end
end
