namespace "generate_sitemap_xml" do
  desc "get_published_urls_of_events"
  task :create_xml_of_published_urls => :environment do
    root_url = {
      production: "https://eventible.com",
      staging: "https://stage.eventible.com",
      development: "http://localhost:3001"
    }
    file_path = Rails.env.development? ? "./events.xml" : "/www/eventible-frontend/current/public/events.xml"
    file = File.new("#{file_path}", "w+")
    xml = Builder::XmlMarkup.new( :target => file, :indent => 1 )
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    xml.urlset(:xmlns =>"http://www.sitemaps.org/schemas/sitemap/0.9") do
      Event.where(:status => "approved").find_each do | url |
        xml.url do
          xml.loc("#{root_url[Rails.env.to_sym]}/#{url.category}/#{url.slug}")
        end
      end
    end
    File.open(file, 'w') { |f| f.write(xml.target!)}
  puts "Events xml file created"
  end
end
