require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'


resource 'Registrations' do
  let!(:user1) { create(:user, email: 'testing@gmail.com')}
  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
  end

  post '/users' do
    parameter :name, 'Full name', required: true
    parameter :email, 'Email Address', required: true
    parameter :password, 'password', required: true
    parameter :password_confirmation, "Password Confirmation", required: true
    
    let!(:name) { 'Prashant Bangar' }
    let!(:email) { 'testing1@gmail.com' }
    let!(:password) { 'welcome' }
    let!(:password_confirmation) { 'welcome' }
    let!(:raw_post) { params.to_json }

    example 'Sign up' do
      explanation 'Signup user with email'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users' do
    parameter :name, 'Full name'
    parameter :email, 'Email Address'
    parameter :password, 'password'
    parameter :password_confirmation, "Password Confirmation"

    let!(:name) { 'Prashant Bangar' }
    let!(:email) { 'testing@gmail.com' }
    let!(:password) { 'welcome' }
    let!(:password_confirmation) { 'welcome' }
    let!(:raw_post) { params.to_json }

    example 'Failed To Signup Due To Invalid Email OR
      Email already has taken by other' do
      explanation 'Failed Signup user with email'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  get '/registrations/confirm' do
    parameter :confirmation_token, 'Confirmation Token', required: true    
    let!(:confirmation_token) { user1.confirmation_token }
    example 'Confirmation token to confirm email address' do
      explanation 'update Confirmation token after confirm email address of user'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/registrations/confirm' do
    parameter :confirmation_token, 'Confirmation Token'
    let!(:confirmation_token) { user1.confirmation_token }
    example 'If User Alerady Confirmed email OR Invalid Confirmation Token' do
      V1::User::Operation::ConfirmUser.
        (params: { confirmation_token: user1.confirmation_token })
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end
end
