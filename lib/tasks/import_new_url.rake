namespace "import_new_url" do
  desc "import_new_records"
  task :import_event_details => :environment do
    logger = Logger.new('log/update_url.log')
    Event.transaction do
      CSV.foreach('./event_url_records.csv') do |row|
        n = row[0]
        record = Event.find_by(id: n)
        if (record)
          record.update(brand_url: row[8].split("/").last)
        end
      rescue ActiveRecord::RecordInvalid => e
        logger.error "Updated unsuccessfully for record #{record.id}"
      end
    end
    logger.info "CSV Records imported successfully."
  end
end
