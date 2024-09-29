namespace "export_events_records" do
  desc "export_events_records_to_csv"
  task :export_events_info => :environment do
    CSV_HEADERS = %w( event_id event_name event_url is_parent edition_year edition_count location status)
    root_url = {
      production: "https://eventible.com",
      staging: "https://stage.eventible.com",
      development: "http://localhost:3001"
    }
    file = File.new("./event_url_records.csv", "w+")
    CSV.open("./event_url_records.csv", "w+") do |csv|
      csv << CSV_HEADERS
      Event.all.each do |event|
        csv << [
          event.id,
          event.title,
          "#{root_url[Rails.env.to_sym]}/#{event.category}/#{event.slug}",
          event.parent_id ? "YES" : "NO",
          event.edition,
          event.parent_id ? Event.where("parent_id = ?", event.parent_id).count : Event.where("parent_id = ?", event.id).count,
          event.country.name,
          event.status
        ]
      end
    end
    puts "CSV File generated"
  end
end
