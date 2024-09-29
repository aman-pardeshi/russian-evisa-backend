require 'rails_helper'

RSpec.describe V1::SessionsController, type: :controller do
  let!(:user1) { create(:user, email:'kl@gmail.com') }
  before do
    request.headers['Accept']= 'application/vnd.eventible.com; version=1'
    request.headers['Content-Type']= 'application/json'
  end

  describe 'POST #create' do
    context 'success' do
      it 'if email address  and password is correct' do
        params = { email: 'kl@gmail.com', password: 'welcome' }
        user1.update(confirmation_token: nil)
        post :create, params: params
        response_data = JSON.parse(response.body)
        expect(response_data['token']).to be_present
        expect(response_data['token'].size).to_not eq(0)
      end
    end

    context 'failure' do
      it 'if email address  and password is incorrect' do
        params = { email: 'kla@gmail.com', password: 'welcaome' }
        user1.update(confirmation_token: nil)
        post :create, params: params
        response_data = JSON.parse(response.body)
        expect(response_data['message']).to be_present
        expect(response_data['message'].size).to_not eq(0)
      end
    end

    context 'Success with google login' do
      it 'if Google Login successfully' do
        params = {
          google_response: {
            accessToken: "ya29.a0AfH6SMBk_emPTvRvqVR2modDBulznrAgHdnn120qrI7gLpqPfEi_ZegxnYljeL5XtgCoXidxNC-wIE3qjRBEISieHXHrj1nEozpOHmgBH_ywfXi_5RembsIWrFaTbj-PeKzghCzJe3N1MYScG8Y-VbufkZP9m17xe6gl",
            profileObj: {
              googleId: "117331728813189843960",
              imageUrl: "https://lh3.googleusercontent.com/a-AOh14Gimkf_-Rw-0425QVtueNFbG1R1fx4oCW35u--YD=s96-c",
              email: "prashant.bangar@joshsoftware.com",
              name: "prashant bangar",
              givenName: "prashant",
              familyName: "bangar",
            }
          }
        }
        post :google, params: params
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_data['token'].size).to be_present
      end
    end

    context 'Success with google login' do
      it 'if Google Login successfully' do
        params = {
          google_response: {
            accessToken: "ya29.a0AfH6SMBk_emPTvRvqVR2modDBulznrAgHdnn120qrI7gLpqPfEi_ZegxnYljeL5XtgCoXidxNC-wIE3qjRBEISieHXHrj1nEozpOHmgBH_ywfXi_5RembsIWrFaTbj-PeKzghCzJe3N1MYScG8Y-VbufkZP9m17xe6gl",
          }
        }
        post :google, params: params
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(ERROR_STATUS_CODE)
        expect(response_data['message'].size).to be_present
        expect(response_data['message']).to eq(
          I18n.t(
            'errors.params_missing',
            params:
            'google_response[:accessToken], google_response[:profileObj]'
          )
        )
      end
    end

    context 'Success with Linkedin login' do
      it 'if Linkedin Login successfully' do
        stub_request(:post,"http://localhost:3000/sessions/
          linkedin?authorization_code=sdfghjklkjhgfd").
            to_return(
              status: 200,
              body: '{"parsed_response": {"localId"}',
              headers: {}
            )
      end
    end
  end
end
