namespace "slug_backup_to_old_slug" do
  desc "get_slug_of_events"
  task :get_slug => :environment do
    Event.update_all('old_slug = slug')
  puts "Events old slug stored with slug values"
  end
end
