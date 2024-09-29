class SendSpeakerCallJob < ApplicationJob
  def perform(speaker_call, speakers, mail_iteration)
    # begin
      speakers.each do |speaker|
        next if speaker.is_email_invalid == true
        
        # response = HTTParty.get("https://api.hunter.io/v2/email-verifier?email=#{speaker.email}&api_key=#{ENV.fetch("HUNTER_API_KEY")}")
        
        # if ((response["data"]["status"] != "invalid" || response["data"]["status"] != "unknown") && response["data"]["score"] >= 70)

          email_tracker_params = {
            speaker_call: speaker_call,
            speaker: speaker,
            mail_trigger: if mail_iteration == 1
              "First Speaker Call"
            elsif mail_iteration == 2
              "Second Speaker Call"
            elsif mail_iteration == 3
              "Third Speaker Call"
            end
          }

          email_tracker = SpeakerCallEmailTracker.new(email_tracker_params)

          if email_tracker.valid?
            email_tracker.save!
          end
          
          case mail_iteration
          when 1
            SpeakerMailer.send_first_speaker_call_mail(speaker, speaker_call, speaker_call.event, email_tracker.id).deliver!
          when 2
            SpeakerMailer.send_second_speaker_call_mail(speaker, speaker_call, speaker_call.event, email_tracker.id).deliver!
          when 3
            SpeakerMailer.send_third_speaker_call_mail(speaker, speaker_call, speaker_call.event, email_tracker.id).deliver!
          end
        # else
        #   speaker.update(is_email_invalid: true)
        # end
      end
    # rescue 
    #   p "Error occured in Hunter API"
    # end
    
  end
end