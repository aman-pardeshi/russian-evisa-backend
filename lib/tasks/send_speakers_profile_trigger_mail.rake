namespace "send_speakers_profile_trigger" do 
  desc "send_speakers_profile_trigger_mail"
  task :send_speakers_profile_trigger => :environment do 

    speakers = Speaker.where(id: [2001..4000]).order(:id)

    speakers.each do |speaker|
      begin
        puts "speaker-#{speaker.id}"
        next if User.where(email: speaker.email).present?

        response = HTTParty.get("https://api.hunter.io/v2/email-verifier?email=#{speaker.email}&api_key=#{ENV.fetch("HUNTER_API_KEY")}")

        if (response["data"]["status"] != "invalid" || response["data"]["status"] != "unknown") && response["data"]["score"] > 70
          password = SecureRandom.hex(8)
          user_attributes = {
            email: speaker.email,
            name: speaker.first_name + " " + speaker.last_name,
            designation: speaker.designation,
            company_name: speaker.company_name,
            password: password,
            dummy_password: password,
            linkedin_url: speaker.linkedin_url,
            twitter_handle: speaker.twitter_url,
            role: 4,
            position_id: speaker.position_id
          }

          user = User.new(user_attributes)
          if user.valid?
            user.skip_confirmation!
            user.skip_password_validation = true
            user.save!
          end
          
          attributes = {
            first_name: speaker.first_name,
            last_name: speaker.last_name,
            email: speaker.email,
            designation: speaker.designation,
            company_name: speaker.company_name
          }

          speaker_member_attribute = {
            user_id: user.id,
            speaker_id: speaker.id,
            invited_by: 1,
            invite_team_token: JWT.encode(attributes, Rails.application.credentials.secret_key_base),
            status: "approved"
          }

          speaker_member = SpeakerMember.create(speaker_member_attribute)

          event_id = speaker.events.present? ? speaker.events[0].id : 304 

          token = speaker_member.invite_team_token
          tracker_attributes = {
            user_id: user.id,
            event_id: event_id,
            mail_trigger: "Speaker Invite Trigger",
            user_status: "New"
          }
          tracker = EmailTracker.create(tracker_attributes)
          UserMailer.existing_speaker_invite_trigger(user, token, tracker.id).deliver!
          puts speaker.id
        end
      rescue
        next
      end
    end
  end
end
