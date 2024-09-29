# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  let!(:user1) { create(:user, role: 'admin') }
  let!(:user1) { create(:user, role: 'admin') }
  let!(:user2) { create(:user, role: 'moderator') }

  before do
    request.headers['Accept'] = 'application/vnd.eventible.com; version=1'
    request.headers['Authorization'] = ApiKeyHandler.encoded_api_key(user1.id)
    request.headers['Content-Type'] = 'application/json'
  end

  describe 'GET #user_listing' do
    context 'success' do
      it 'User listed successfully' do
        get :index
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_data['users']).to be_present
      end
    end

    context 'failure' do
      it 'Users not listed successfully when user is not authorized' do
        user1.update(role: nil)
        get :index
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(ERROR_STATUS_CODE)
        expect(response_data['message']).to eq(I18n.t('errors.unauthorized_user'))
      end
    end
  end

  describe "Send Invitation to member" do
    context 'success' do
      it 'Invitation sent successfully' do
        params = {
          email:'xyz@gmail.com',
          name:'xyz@ert.com',
          role:'moderator'
        }
        post :send_invitation, params: params
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_data['message']).to be_present
        expect(response_data['message']).to eq(
          I18n.t(
            'devise.invitations.send_instructions',
            email: params[:email]
          )
        )
      end
    end

    context 'Failure' do
      it 'Invitation sent failed due to duplicate email id' do
        params = {
          email: user1.email,
          name:'xyz@ert.com',
          role:'moderator'
        }
        post :send_invitation, params: params
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(ERROR_STATUS_CODE)
        expect(response_data['message']).to be_present
      end

      it 'Invitation sent failed due to unauthorised user' do
        params = {
          email: 'exy@gmail.com',
          name:'xyz@ert.com',
          role:'moderator'
        }
        user1.update(role: nil)
        post :send_invitation, params: params
        response_data = JSON.parse(response.body)
        expect(response.status).to eq(ERROR_STATUS_CODE)
        expect(response_data['message']).to be_present
      end
    end
  end
end
