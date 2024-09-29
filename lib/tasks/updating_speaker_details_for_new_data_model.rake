namespace "updating_speaker_details_for_new_data_model" do
  desc "updating speaker details as per new data modeling"
  task :update_degrees => :environment do

    speakers = Speaker.all.order(:id)

    speakers.each do |speaker|
      degree = speaker.degrees
      
      if degree.present?
        SpeakerDegree.new(
          speaker: speaker,
          title: degree
        ).save!
        speaker.update(degrees: nil)
      end

      puts speaker.id
    end
  end
end