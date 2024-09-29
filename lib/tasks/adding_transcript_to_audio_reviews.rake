namespace "adding_transcript_to_audio_review" do
  desc "adding transcription to all approved audio_review"
  task :adding_transcript_to_audio_review => :environment do 

    audio_reviews = AudioReview.where(status: 'approved').order(:id)

    audio_reviews.each do |audio|
      next if audio.transcript.present?

      puts "Started Transcription audio-#{audio.id}"

      Aws.config.update({
        region: ENV.fetch('REGION'),
        credentials: Aws::Credentials.new(ENV.fetch('ACCESS_KEY_ID'),
        ENV.fetch('SECRET_ACCESS_KEY'))
      })
      client = Aws::TranscribeService::Client.new
      
      response = client.start_transcription_job({
        transcription_job_name: "#{Rails.env}-transcriptionJob#{audio.id}",
        language_code: 'en-US', # Specify the language code of your audio
        media: {
          media_file_uri: "https://#{ENV.fetch('BUCKET')}.s3.amazonaws.com/audio_review/audios/#{audio.id}/blob"
        },
        output_bucket_name: ENV.fetch('BUCKET'),
        output_key: "transcriptions/#{audio.id}/transcript.txt"
      })

      sleep 30
        
      response_status = client.get_transcription_job({
        transcription_job_name: "#{Rails.env}-transcriptionJob#{audio.id}"
      })[:transcription_job][:transcription_job_status]

      while response_status != "COMPLETED"
        sleep 30
        response_status = client.get_transcription_job({
        transcription_job_name: "#{Rails.env}-transcriptionJob#{audio.id}"
        })[:transcription_job][:transcription_job_status]
      end

      if response_status == "COMPLETED"
        s3 = Aws::S3::Client.new
        transcription_response = s3.get_object(bucket: ENV.fetch('BUCKET'), key: "transcriptions/#{audio.id}/transcript.txt")
        transcription_json = transcription_response.body.read
        transcription_parse = JSON.parse(transcription_json)
        transcription = transcription_parse["results"]["transcripts"][0]["transcript"].gsub(" uh ", " ").gsub(" um ", " ").gsub("Um ", "").gsub("Uh ", "")

        AudioReview.find(audio.id).update(transcript: transcription)
      end
      puts "Completed Transcription audio-#{audio.id}"
    end
  end
end
