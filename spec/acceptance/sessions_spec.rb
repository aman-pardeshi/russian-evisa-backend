require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Sessions' do
  let!(:user1) { create(:user, email:'kl@gmail.com')}
  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
  end

  post '/sessions' do
    parameter :email, 'Email Address', required: true
    parameter :password, 'password', required: true
    let!(:email) { user1.email }
    let!(:password) { user1.password }
    let!(:raw_post) { params.to_json }

    example 'Sign in' do
      user1.update(confirmation_token: nil)
      explanation 'Sign in user with email'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/sessions' do
    parameter :email, 'Email Address'
    parameter :password, 'password'
    let!(:email) { user1.email }
    let!(:password) { '123456' }
    let!(:raw_post) { params.to_json }

    example 'Failure response of sign in' do
      explanation 'if email/password in invalid
        or user doesnot confirmed email '
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  post '/sessions/google' do
    parameter :google_response,
      'Response Which is sent by google after login',
      required: true
    parameter :accessToken,
      'Access Token of Google',
      required: true, scope: :google_response
    parameter :profileObj, "Profile Object Of User",
      required: true, scope: :google_response
    let!(:google_response) {
      {
        accessToken: "ya29.a0AfH6SMBk_emPTvRvqVR2modDBulznrAgHdnn120qrI7gLpqPfEi_ZegxnYljeL5XtgCoXidxNC-wIE3qjRBEISieHXHrj1nEozpOHmgBH_ywfXi_5RembsIWrFaTbj-PeKzghCzJe3N1MYScG8Y-VbufkZP9m17xe6gl",
        profileObj:{
          googleId: "117331728813189843960",
          imageUrl: "https://lh3.googleusercontent.com/a-AOh14Gimkf_-Rw-0425QVtueNFbG1R1fx4oCW35u--YD=s96-c",
          email: "prashant.bangar@joshsoftware.com",
          name: "prashant bangar",
          givenName: "prashant",
          familyName: "bangar",
        }
      }
    }
    let!(:raw_post) { params.to_json }
    example 'Sign in With Google' do
      user1.update(confirmation_token: nil)
      explanation 'Sign in user with Google'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/sessions/google' do
    parameter :google_response, 'Response Which is sent by google after login'
    parameter :profileObj, "Profile Object Of User", scope: :google_response
    let!(:google_response) {
      {
        profileObj:{
          googleId: "117331728813189843960",
          imageUrl: "https://lh3.googleusercontent.com/a-AOh14Gimkf_-Rw-0425QVtueNFbG1R1fx4oCW35u--YD=s96-c",
          email: "prashant.bangar@joshsoftware.com",
          name: "prashant bangar",
          givenName: "prashant",
          familyName: "bangar",
        }
      }
    }
    let!(:raw_post) { params.to_json }
    example 'Failure Response if user sent invalid params' do
      user1.update(confirmation_token: nil)
      explanation 'Failure Response of Sign in user with Google'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end
end
