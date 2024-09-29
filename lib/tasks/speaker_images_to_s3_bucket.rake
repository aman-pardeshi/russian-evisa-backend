require 'open-uri'
require 'aws-sdk-s3'

namespace "speaker_images_to_s3_bucket" do 
  desc "Update the images in speaker table"
  task speaker_images_upload_task: :environment do 

    Aws.config.update({
      region: ENV.fetch('REGION'),
      credentials: Aws::Credentials.new(ENV.fetch('ACCESS_KEY_ID'),
      ENV.fetch('SECRET_ACCESS_KEY'))
    })
      

      speakers = Speaker.where('image_url like ?', "https://media.licdn.com%")  


      puts speakers.count
      
      speakers.each do |speaker|
        url = speaker.image_url

        if url != nil
          begin 
            image_data = open(url).read

            s3 = Aws::S3::Resource.new
            bucket_name = ENV.fetch('BUCKET')
            key = "speakers/profile/#{speaker.id}/#{speaker.slug}.jpg"
            
            s3.bucket(bucket_name).object(key).put(body: image_data)

            s3_url = "https://#{bucket_name}.s3.amazonaws.com/#{key}"

            speaker.update(image_url: s3_url)
          rescue OpenURI::HTTPError
            next
          end
        end
      end


      puts "All the speakers images have been changed"
  end
end

