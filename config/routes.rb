# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'v1/registrations'
  }

  get 'registrations/confirm', to: 'registrations#confirm'


  resources :sessions, only: [:create] do
    collection do
      post :linkedin
      post :google
    end
  end
  
  resources :users, only: [:index, :update, :show, :destroy] do
    collection do
      post :send_invitation
      post :reset_password
      post :accept_invitation
      post :verify_invitation_token
      post :verify_reset_password_token
      post :update_password
      post :forgot_password
      get :check_email
      get :reviewed_events
      get :saved_reviews
      get :bookmarked_events
      get :my_rewards
      get :deactivate_account
      get :content_marketing_request
      get :run_campaign_on_your_behalf
      get :send_remainder
      put :unsubscribe_user
      post :send_otp
    end
  end

  resources :dashboards do
    collection do
      get :admin
      get :organizer
      get :organizer_events
      get :event_statistics
      get :organizer_event_list
    end
  end

  resources :evisa_applications, only: [:create] do 
    collection do
      post :delete
      get :get_all_applications
      get :get_all_submitted_applications
      post :update_applicant_details
      post :update_passport_details
      post :upload_documents
      post :update_employement_details
      post :update_relatives_details
      post :update_additional_details
      post :get_application_details
      post :update_status
      post :track_status
      
    end
  end

  resources :admin do 
    collection do
      post :submitted_applications
      post :applied_applications
      post :all_applications
      post :apply_visa
      post :approve_visa
      post :reject_visa
    end
  end

  resources :reports do
    collection do
      post :submitted_applications
      post :applied_visa
      post :processed_visa
      post :accounts_report
      post :incomplete_applications
    end
  end
end
