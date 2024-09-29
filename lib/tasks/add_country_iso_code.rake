namespace "country_iso_code" do
  desc "add_country_iso_code"
  task :add_coutry_code => :environment do
    COUNTRY_NAME_HASH.each {|country| Country.find_by(name: country[:name]).update(code: country[:code]) }
  end
end
