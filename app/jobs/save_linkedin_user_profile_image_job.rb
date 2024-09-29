class SaveLinkedinUserProfileImageJob < ApplicationJob
    require 'open-uri'

    queue_as :default


    def perform(user_id, profile_url)
      user = User.find(user_id)

      begin
        img = URI.open("#{user.name}.jpg", 'wb')
        IO.copy_stream(URI.open(profile_url), img)
        user.update(profile: img)
      
      rescue OpenURI::HTTPError => e
        Rails.logger.error("Error opening URL: #{e.message}")
      rescue StandardError => e
        Rails.logger.error("Error updating user profile: #{e.message}")
      end
    end
end
