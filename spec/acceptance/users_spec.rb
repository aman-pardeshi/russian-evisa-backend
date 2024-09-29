# frozen_string_literal: true

require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'

resource 'Users' do
  let!(:user1) { create(:user,  role: 'admin') }
  let!(:user2) { create(:user, name:'xyz nmp', invitation_token: "asdfghjkl", reset_password_token: "sdfghjkl") }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
    header 'Authorization', ApiKeyHandler.encoded_api_key(user1.id)
  end

  get '/users' do

    parameter :page , "page number for pagination", type: :integer
    parameter :limit, "Limit Per Page For Pagination", type: :integer
    parameter :query, "Search value for search", type: :string

    let!(:page) { 1 }
    let!(:limit) { 2 }
    let!(:query) { 'xy'}
    let!(:raw_post) { params.to_json }
    example 'User Listing' do
      explanation 'User Listing'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/send_invitation' do
    parameter :email, 'User email Id ', type: :string
    parameter :name, 'User Name', type: :string, required: true
    parameter :role, 'user role [moderator]', type: :string, required: true

    let!(:email) { 'xyz@fgh.com' }
    let!(:name) { 'Xert Swer' }
    let!(:role) { 'moderator' }
    let!(:raw_post) { params.to_json }

    example 'Send invitation to user' do
      explanation 'Send invitation to user for moderator role'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/send_invitation' do
    parameter :email, 'User email Id ', type: :string
    parameter :name, 'User Name', type: :string, required: true
    parameter :role, 'user role [moderator]', type: :string, required: true

    let!(:email) { user1.email }
    let!(:name) { 'Xert Swer' }
    let!(:role) { 'moderator' }
    let!(:raw_post) { params.to_json }

    example 'Send invitation to alerady exits user' do
      explanation 'Send invitation to user for moderator role'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  post '/users/send_invitation' do
    parameter :email, 'User email Id ', type: :string
    parameter :name, 'User Name', type: :string, required: true
    parameter :role, 'user role [moderator]', type: :string, required: true

    let!(:email) { 'zec@fmail.com' }
    let!(:name) { 'Xert Swer' }
    let!(:role) { 'moderator' }
    let!(:raw_post) { params.to_json }

    example 'unauthorised user cant Send invitation to user' do
      user1.update(role:nil)
      explanation 'if unathorised user send invitation to user then error will be return'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end

  delete '/users/:id' do
    parameter :id, 'User Id ', type: :integer, required: true

    let!(:id) { user1.id }
    let!(:raw_post) { params.to_json }

    example 'user delete' do
      explanation 'delete user'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/users/:id' do
    parameter :id, 'User Id ', type: :integer, required: true

    let!(:id) { user1.id }
    let!(:raw_post) { params.to_json }

    example 'get user details' do
      explanation 'get user details'
      do_request
      expect(status).to eq(200)
    end
  end

  put '/users/:id' do
    parameter :id, "user id", type: :integer, required: true
    parameter :name, "user email", type: :string
    parameter :company_name, "user company name", type: :string
    parameter :linkedin_url, "user linkedin id", type: :string
    parameter :twitter_handle, "user twitter id", type: :string
    parameter :email, "user email", type: :string
    parameter :mobile_number, "user mobile number", type: :string
    parameter :designation, "user job role", type: :string

    let!(:id) { user1.id }
    let!(:name) { 'Xyz Pqr' }
    let!(:company_name) { 'adsf' }
    let!(:raw_post) { params.to_json }

    example 'update user details' do
      explanation 'update user details'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/accept_invitation' do
    let(:invitation_token_string) do
      raw, enc = Devise.token_generator.generate(User, :invitation_token)
      user2.update(invitation_token: enc)
      raw
    end
    parameter :invitation_token, 'Send Invitation Token', type: :string
    parameter :password, 'Send Password', type: :string, required: true
    parameter :password_confirmation, 'Send Password Confirmation', type: :string, required: true
    let!(:invitation_token) { invitation_token_string }
    let!(:password) { 'welcome' }
    let!(:password_confirmation) { 'welcome' }
    let!(:raw_post) { params.to_json }

    example 'Accept invitation to user' do
      explanation 'Accept invitation of moderator to update password'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/reset_password' do
    let(:reset_password_string) do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user2.update(reset_password_token: enc)
      raw
    end
    parameter :reset_password_token, 'Send Reset Password Token', type: :string
    parameter :password, 'Send Password', type: :string, required: true
    parameter :password_confirmation, 'Send Password Confirmation', type: :string, required: true

    let!(:reset_password_token) { reset_password_string }
    let!(:password) { 'welcome' }
    let!(:password_confirmation) { 'welcome' }
    let!(:raw_post) { params.to_json }

    example 'Send Reset Password Token of user to update password' do
      explanation 'Send Reset Password Token of user to update password'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/verify_reset_password_token' do
    parameter :reset_password_token, 'Send Reset Password Token', type: :string
    let(:reset_password_string) do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user2.update(reset_password_token: enc)
      raw
    end
    let!(:reset_password_token) { reset_password_string }
    let!(:raw_post) { params.to_json }

    example 'Verify Reset Password Token' do
      explanation 'Valid Reset Password Token'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/verify_reset_password_token' do
    parameter :reset_password_token, 'Send Reset Password Token', type: :string

    let!(:reset_password_token) { "dfghjkl" }
    let!(:raw_post) { params.to_json }

    example ' if Reset Password Token is invalid' do
      explanation 'invalid Reset Password Token'
      do_request
      expect(status).to eq(422)
    end
  end

  post '/users/verify_invitation_token' do
    let(:invitation_token_string) do
      raw, enc = Devise.token_generator.generate(User, :invitation_token)
      user2.update(invitation_token: enc)
      raw
    end
    parameter :invitation_token, 'Send Invitation Token', type: :string

    let!(:invitation_token) { invitation_token_string}
    let!(:raw_post) { params.to_json }

    example ' if Invitation Token is valid' do
      explanation 'Invitation Token'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/verify_invitation_token' do
    let(:invitation_token) do
      raw, enc = Devise.token_generator.generate(User, :invitation_token)
      user2.update(invitation_token: enc)
    end
    parameter :invitation_token, 'Send Invitation Token', type: :string

    let!(:invitation_token) { "dfghjkl" }
    let!(:raw_post) { params.to_json }

    example ' if Invitation Token is invalid' do
      explanation 'invalid Invitation Token'
      do_request
      expect(status).to eq(422)
    end
  end

  post '/users/update_password' do
    parameter :old_password, 'Send old password', type: :string
    parameter :password, 'Send password', type: :string
    parameter :password_confirmation, 'Send password confirmation', type: :string

    let!(:old_password) { "welcome" }
    let!(:password) { "welcome1" }
    let!(:password_confirmation) { "welcome1" }
    let!(:raw_post) { params.to_json }

    example ' if old password matched and updated successfully' do
      explanation 'Successfully updated password'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/update_password' do
    parameter :old_password, 'Send old password', type: :string
    parameter :password, 'Send password', type: :string
    parameter :password_confirmation, 'Send password confirmation', type: :string

    let!(:old_password) { "welcome1" }
    let!(:password) { "welcome2" }
    let!(:password_confirmation) { "welcome2" }
    let!(:raw_post) { params.to_json }

    example ' if old password donest not matched' do
      explanation 'failed updated password'
      do_request
      expect(status).to eq(422)
    end
  end
  
  post '/users/forgot_password' do
    parameter :email, 'Send email', type: :string

    let!(:email) { user1.email }
    let!(:raw_post) { params.to_json }

    example 'if email is valid then sent reset password link' do
      explanation 'send reset password link'
      do_request
      expect(status).to eq(200)
    end
  end

  post '/users/forgot_password' do
    parameter :email, 'Send email', type: :string

    let!(:email) { 'xyz@gmail.com' }
    let!(:raw_post) { params.to_json }

    example 'if email is invalid then sent error' do
      explanation 'Invalid email'
      do_request
      expect(status).to eq(422)
    end
  end

  get '/users/check_email' do
    parameter :email, 'Email For check present or not', type: :string, required: true

    let!(:email) { 'xyz@gmail.com' }
    let!(:raw_post) { params.to_json }

    example 'if email is unique' do
      explanation 'Unique email address of user'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/users/check_email' do
    parameter :email, 'Email For check present or not', type: :string, required: true

    let!(:email) { user2.email }
    let!(:raw_post) { params.to_json }

    example 'if email is already present in system' do
      explanation 'already present in system'
      do_request
      expect(status).to eq(422)
    end
  end

  context "User Profile APIS" do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, status: 'approved', created_by: user, owner: user) }
    let!(:campaign_link) { create(:campaign_link, event_id: event.id) }
    let!(:review) { create(:review, campaign_link_id: campaign_link.id, reviewer: user, event_id: event.id)}
    let!(:user_insight) { create(:user_insight, resource: event, is_bookmarked: true, user: user)}
    let!(:user_insight1) { create(:user_insight, resource: review, is_bookmarked: true, user: user)}
  
    before do
      header 'Authorization', ApiKeyHandler.encoded_api_key(user.id)
    end

    context "Get Saved Reviews" do
      parameter :page , "page number for pagination", type: :integer
      parameter :limit, "Limit Per Page For Pagination", type: :integer
      
      let!(:page) { 1 }
      let!(:limit) { 2 }
      let!(:raw_post) { params.to_json }

      get 'users/saved_reviews' do
        example "Get Users Saved Reviews" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context "Get Reviewed Events" do
      parameter :page , "page number for pagination", type: :integer
      parameter :limit, "Limit Per Page For Pagination", type: :integer

      let!(:page) { 1 }
      let!(:limit) { 2 }
      let!(:raw_post) { params.to_json }

      get "users/reviewed_events" do
        example "Get Reviewed events" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context "Get Reward Amount" do
      parameter :page , "page number for pagination", type: :integer
      parameter :limit, "Limit Per Page For Pagination", type: :integer

      let!(:page) { 1 }
      let!(:limit) { 2 }
      let!(:raw_post) { params.to_json }

      get "users/my_rewards" do
        example "Get My Rewards" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context "Get Bookmarked Events" do
      parameter :page , "page number for pagination", type: :integer
      parameter :limit, "Limit Per Page For Pagination", type: :integer

      let!(:page) { 1 }
      let!(:limit) { 2 }
      let!(:raw_post) { params.to_json }
      get "users/bookmarked_events" do
        example "Get Bookmarked events" do
          do_request
          expect(status).to eq(200)
        end
      end
    end

    context "Deactivate Account" do
      get "users/deactivate_account" do
        example "Deactivate Account" do
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
