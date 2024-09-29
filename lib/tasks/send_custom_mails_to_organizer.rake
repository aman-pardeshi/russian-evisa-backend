namespace "send_custom_mails_to_organizer" do 
  desc "To send custom mails to organizer when needed"
  task :send_mail => :environment do 

    speakers_ids = SpeakerProfileVerification.all.pluck(:speaker_id).uniq

    speakers = Speaker.where(id: speakers_ids)

    speakers_users = speakers.map{|speaker| speaker.user}

    users = User.where(role: "organizer", unsubscribe_status: [false, nil])

    users.each_with_index do |user, i|
      puts "users-#{user.id}"

      if Rails.env.production?
        next if user.email == "ccollinge@themartechsummit.com"
        response = HTTParty.get("https://api.hunter.io/v2/email-verifier?email=#{user.email}&api_key=#{ENV.fetch("HUNTER_API_KEY")}")

        if (response["data"]["status"] != "invalid" || response["data"]["status"] != "unknown") && response["data"]["score"] > 70
          UserMailer.send_custom_mail_to_user(user).deliver!
        end
      else
        if i < 1
          UserMailer.send_custom_mail_to_user(user).deliver!
       
          puts "send mail to user-#{user.id}"
        end
      end
    end

    speakers_users.each_with_index do |user, i|
      puts "users-#{user.id}"

      if Rails.env.production?
        next if user.email == "ccollinge@themartechsummit.com"
        response = HTTParty.get("https://api.hunter.io/v2/email-verifier?email=#{user.email}&api_key=#{ENV.fetch("HUNTER_API_KEY")}")

        if (response["data"]["status"] != "invalid" || response["data"]["status"] != "unknown") && response["data"]["score"] > 70
          UserMailer.send_custom_mail_to_user(user).deliver!
        end
      else
        if i < 1
          UserMailer.send_custom_mail_to_user(user).deliver!
       
          puts "send mail to user-#{user.id}"
        end
      end
    end
  end
end
