require 'rails_helper'

RSpec.describe V1::User::Operation::Create, type: :operation   do
  context 'Register user and confirm user' do
    let!(:user) { create(:user, email:'testing@gmail.com')}
    let!(:user_params) {
      ActionController::Parameters.
        new(
          {
            name:'prashant bangar',
            email:'testing@gmail.com',
            password: 'password',
            password_confirmation: 'password'
          }
        )
    }

    it 'is valid user with invalid password' do
      user_params[:password] = "password1"
      result = V1::User::Operation::Create.(params: user_params)
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
    end
    
    it 'is valid user with already exits email id' do
      result = V1::User::Operation::Create.(params: user_params)
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
    end

    it 'is user created successfully and confirmation mail sent after user create' do
      user_params[:email] = "testing1@gmail.com"
      result = V1::User::Operation::Create.(params: user_params)
      expect(result.success?).to be_truthy
      expect(result[:user].confirmation_token.present?).to be_truthy
      expect(result[:user].confirmation_sent_at.present?).to be_truthy
    end
  end
end
