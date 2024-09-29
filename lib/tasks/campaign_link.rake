namespace "campaign_link" do
  desc "update url_ids using link_tbr"
  task :update_existing_url_ids => :environment do
    CampaignLink.where.not(link_tbr: nil).find_each do |link|
      link.update_columns(url_id: link.link_tbr.split("/").last)
    end

    puts "Updated url ids"
  end
end