class SpeakerMailer < ApplicationMailer

  def send_first_speaker_call_mail(speaker, speaker_call, event, tracker_id)
    @speaker = speaker
    @speaker_call = speaker_call
    @event = event
    @organizer = speaker_call.user
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}&type=speaker_call"

    mail(to: @speaker.email, subject: "Opportunity to Speak at #{@event.title}")
  end

  def send_second_speaker_call_mail(speaker, speaker_call, event, tracker_id)
    @speaker = speaker
    @speaker_call = speaker_call
    @event = event
    @organizer = speaker_call.user
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}&type=speaker_call"

    mail(to: @speaker.email, subject: "Gentle Reminder: Speaking Opportunity for You")
  end

  def send_third_speaker_call_mail(speaker, speaker_call, event, tracker_id)
    @speaker = speaker
    @speaker_call = speaker_call
    @event = event
    @organizer = speaker_call.user
    @tracker_id=tracker_id
    @tracking_link = "#{ENV.fetch("BACKEND_URL")}/pixel_trigger?version=v3&id=#{@tracker_id}&type=speaker_call"

    mail(to: @speaker.email, subject: "Opportunity to Speak at #{@event.title}")
  end

  def send_speaker_interest_mail_to_organizer(user, event, speaker)
    @user = user
    @event = event
    @speaker = speaker

    mail(to: @user.email, subject: "#{@speaker.first_name} is interested in #{@event.title}")
  end
end