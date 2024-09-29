namespace "send_remaining_trigger_for_speaker_call" do
  desc "Send 2nd and 3rd mail trigger for speaker calls"
  task :send_triggers => :environment do 
    
    speaker_calls_for_second_trigger = SpeakerCall.where("date(created_at) = ?", (Date.current - 7).strftime)

    # speaker_call_for_third_trigger = SpeakerCall.where("date(created_at) = ?", (Date.current - 15).strftime)

    speaker_calls_for_second_trigger.each do |call|
      speaker_ids = SpeakerCallEmailTracker.where(speaker_call_id: call.id, mail_trigger: "First Speaker Call").pluck(:speaker_id)

      interested_speaker_ids = SpeakerCallInterest.where(speaker_call_id: call.id).pluck(:speaker_id)

      speaker_ids = speaker_ids.select{ |id| !interested_speaker_ids.include?(id) }

      speakers = Speaker.where(id: speaker_ids, is_email_invalid: nil)

      speakers = speakers.select{ |speaker| speaker.user.unsubscribe_status != true }

      SendSpeakerCallJob.perform_later(call, speakers, 2)
    end

    # speaker_call_for_third_trigger.each do |call|
    #   speaker_ids = SpeakerCallEmailTracker.where(speaker_call_id: call.id, mail_trigger: "First Speaker Call").pluck(:speaker_id)

    #   speakers = if speaker_call.event.job_title_id.present? && speaker_call.event.job_title_id != 0
    #     Speaker.where(job_title_id: speaker_call.event.job_title_id, is_email_invalid: nil)
    #   else
    #     Speaker.where(industry_id: speaker_call.event.industry_id, is_email_invalid: nil)
    #   end

    #   speakers = speakers.select{ |speaker| speaker.user.unsubscribe_status != true }

    #   SendSpeakerCallJob.perform_later(call, speakers, 3)
    # end
  end
end