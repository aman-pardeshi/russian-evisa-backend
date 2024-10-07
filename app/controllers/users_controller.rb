# frozen_string_literal: true

module V1
  class UsersController < BaseController
    skip_before_action :authenticate!,
      only: %i[accept_invitation reset_password
        verify_invitation_token verify_reset_password_token
        forgot_password check_email unsubscribe_user]

    def index
      run V1::User::Operation::Index do |result|
        return cache_render V1::UserSerializer, result[:users], meta: pagination_hash(result[:total_count], result[:current_count])
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def send_invitation
      run V1::User::Operation::SendInvitation do |result|
        return render json: { message: result[:message] }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def show
      run V1::User::Operation::Show do |result|
        return render json: { data: V1::UserSerializer.new(result[:user], be_trendy: true).as_json }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def update
      run V1::User::Operation::Update do |result|
        return render json: { data: V1::UserSerializer.new(result[:user], be_trendy: true).as_json }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def destroy
      run V1::User::Operation::Delete do|result|
        return render json: { message: I18n.t('success.action', action:' user deleted') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def reset_password
      run V1::User::Operation::ResetPassword do|result|
        return render json: { message: I18n.t('success.action', action:' Password reseted') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def accept_invitation
      run V1::User::Operation::AcceptInvitation do|result|
        return render json: { message: I18n.t('success.action', action:'Invitation Accepted') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def verify_invitation_token
      run V1::User::Operation::VerifyInvitationToken do|result|
        return render json: { message: I18n.t('success.action', action:'Invitation token validate') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def verify_reset_password_token
      run V1::User::Operation::VerifyResetPasswordToken do|result|
        return render json: { message: I18n.t('success.action', action:'reset_password token validate') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def update_password
      run V1::User::Operation::UpdatePassword do|result|
        return render json: { message: I18n.t('success.action', action: 'Password updated')}
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def forgot_password
      run V1::User::Operation::ForgotPassword do|result|
        return render json: { message: I18n.t('success.action', action:'Reset Password link sent')}
      end

      render json: { message:  result[:error] }, status: ERROR_STATUS_CODE
    end

    def check_email
      run V1::User::Operation::ValidateEmail do|result|
        return render json: { message: I18n.t('success.uniq_email') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def reviewed_events
      run V1::User::Operation::ReviewedEvents do|result|
        return cache_render V1::UserEventsSerializer, result[:reviewed_events],
        meta: pagination_hash(result[:total_count], result[:current_count])
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def saved_reviews
      run V1::User::Operation::SavedReviews do|result|
        return cache_render V1::ReviewSerializer, result[:saved_reviews],
        current_user: current_user,
        meta: pagination_hash(result[:total_count], result[:current_count])

      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def bookmarked_events
      run V1::User::Operation::BookmarkedEvents do|result|
        return cache_render V1::UserEventsSerializer, result[:bookmarked_events],
          meta: pagination_hash(result[:total_count], result[:current_count])
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def my_rewards
      run V1::User::Operation::MyRewards do|result|
        return cache_render V1::RewardSerializer, result[:my_rewards],
        meta: pagination_hash(result[:total_count], result[:current_count])
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def deactivate_account
      run V1::User::Operation::Deactivate do|result|
        return render json: {message: I18n.t("success.action", action: 'account deactivated')}
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def content_marketing_request
      run V1::User::Operation::ContentMarketingRequest do|result|
        return render json: { data: V1::ContentMarketingSerializer.new(result[:content_marketing]).as_json }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def run_campaign_on_your_behalf
      run V1::User::Operation::RunCampaignOnYourBehalf do|result|
        return render json: { message: I18n.t("success.action", action: 'request submitted') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def send_remainder
      run V1::User::Operation::SendRemainderMail do|result|
        return render json: { message: I18n.t("success.action", action: 'remainder sent') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end

    def unsubscribe_user
      run V1::User::Operation::UnsubscribeUser do|result|
        return render json: { message: I18n.t("success.action", action: 'Unsubscribed') }
      end

      render json: { message: result[:error] }, status: ERROR_STATUS_CODE
    end
  end
end
