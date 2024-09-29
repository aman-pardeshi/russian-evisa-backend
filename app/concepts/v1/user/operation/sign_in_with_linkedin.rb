module V1::User::Operation 
  class SignInWithLinkedin < Trailblazer::Operation

    step -> (ctx, params:, **) { params[:authorization_code].present? }
    fail V1::Api::Macro.ParamsMissing(params: 'authorization_code')

    step :get_linked_in_access_token
    step :get_email_address
    step :get_profile_info
    step :find_or_create_user
    step :create_or_update_linkedin_account
    fail :failed_to_login, fail_fast: true

    def get_linked_in_access_token(ctx, params:, **)
      response =
        HTTParty.get("#{LINKEDIN_ACCESS_TOKEN_URL}?grant_type=authorization_code&" \
            "redirect_uri=#{ENV.fetch("LINKEDIN_REDIRECT_URL")}&" \
            "client_id=#{ENV.fetch("LINKEDIN_CLIENT_ID")}&" \
            "client_secret=#{ENV.fetch("LINKEDIN_CLIENT_SECRET")}&" \
            "code=#{params[:authorization_code]}"
          )
      return false if !response.code.eql? 200
      access_token = response["access_token"]
      expires_in = response["expires_in"]
      ctx[:auth_hash] = {
        access_token: access_token,
        expires_in: expires_in
      }
    end

    def get_email_address(ctx, auth_hash:, **)
      response =
        HTTParty.
          get(
              "#{LINKEDIN_API_HOST_URL}/#{LINKEDIN_GET_EMAIL_QUERY_PARAMS}",
              headers: {
                "Authorization" => "Bearer #{auth_hash[:access_token]}"
              }
            )
      return false if !response.code.eql? 200
      ctx[:email] = response["elements"].first["handle~"]["emailAddress"]
    end

    def get_profile_info(ctx, auth_hash:, **)
      response =
        HTTParty.
          get(
            "#{LINKEDIN_API_HOST_URL}/#{LINKEDIN_PROFILE_INFO_QUERY_PARAMS}",
            headers: {
              "Authorization" => "Bearer #{auth_hash[:access_token]}"
            }
          )
      return false if !response.code.eql? 200
      ctx[:name] =
        "#{response["firstName"]["localized"]["en_US"]} "\
        "#{response["lastName"]["localized"]["en_US"]}"
      auth_hash[:profile] =
        {
        url:
          (response["profilePicture"]["displayImage~"]["elements"].
          last["identifiers"][0]["identifier"] rescue "")
        }       
    end

    def find_or_create_user(ctx, auth_hash:, **)
      user = User.find_or_initialize_by(email:ctx[:email])
      user.skip_password_validation = true
      user.name = ctx[:name]
      user.skip_confirmation_notification!
      ctx[:user] = user if user.save! && user.active?
      SaveLinkedinUserProfileImageJob.perform_later(user.id, auth_hash[:profile][:url])
    end

    def create_or_update_linkedin_account(ctx, user:, auth_hash:, **)
      begin
        linkedin_account = LinkedinAccount.find_or_initialize_by(user_id: user.id)
        linkedin_account.auth_hash = auth_hash
        linkedin_account.save!
      rescue
        false
      end
    end

    def failed_to_login(ctx, **)
      ctx[:error] = I18n.t('errors.social_login_failed', account: 'Linkedin')
    end
  end
end
