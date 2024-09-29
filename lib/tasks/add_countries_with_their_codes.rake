namespace 'country_iso_code' do
  desc 'add_standard_countries_with_their_codes'
  task :add_countires_with_codes => :environment do
    COUNTRY_CODE_FILE_PATH= "#{Rails.root}/public/country_code.csv".freeze
    csv_text = File.read(COUNTRY_CODE_FILE_PATH)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      ctry = row.to_hash
      if !Country.where(name: ctry["name"]).exists?
        Country.create!(ctry)
      end
    end
    pp "Countries with their code added successfully"
  end
end
