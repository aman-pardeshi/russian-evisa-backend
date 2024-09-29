namespace "upload_flags_to_countries" do
  desc "Uploading the flags of countries to aws"
  task :upload => :environment do 
    countries = Country.all.order(:id)
    countries.each do |country|
      puts country.name
      flag = "#{Rails.root}/public/flags/#{country.code.downcase}.svg"

      next if country.flag.present?
      next if country.name == "Other"

      country.update(flag: File.open(flag))
    end
  end
end