namespace "updating_speaker_images_url" do
  desc "updating_speaker_images_url"
  task :updating_speaker_images_url => :environment do

    speakers = Speaker.all.order(:id)

    speakers.each do |speaker|
      image_url = speaker.image_url.url
      
      if Rails.env == "preproduction" or Rails.env == "development"
        if image_url.present? 
          speaker.update_column(:image_url, "#{speaker.slug + ".jpg"}")
        end
        puts "Speaker-#{speaker.id}"
      elsif Rails.env == "production"
        if image_url.present? 
          speaker.update_column(:image_url, "#{image_url.split('/').last}")
        end
        puts "Speaker-#{speaker.id}"
      end    
    end
  end
end