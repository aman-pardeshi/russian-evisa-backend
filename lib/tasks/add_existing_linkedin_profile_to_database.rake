require 'open-uri'
require 'net/http'
namespace "add_existing_linkedin_profile_to_database" do 
  desc "Fetch and save LinkedIn profile pictures for existing users"
  task linkedin_profile_update: :environment do
    LoginAccount.where(type: "LinkedinAccount").each do |account|
      begin 
        profile_url = account.auth_hash.dig("profile", "url")
        user_id = account.user_id
        user = User.find(user_id)

        uri = URI(profile_url)
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          profile_img = URI.open("#{user.name}.jpg", 'wb')
          IO.copy_stream(URI.open(profile_url), profile_img)
          user.update(profile: profile_img)
        else
            raise StandardError, "Failed to fetch profile picture for user #{user_id}. HTTP status: #{response.code}"
        end
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end
    puts "linkedin profile update rake task ran successfully"
  end
end

