require 'aws-sdk'

namespace :utils do
  task :db_backup => :environment do
    next unless Rails.env.production?

    # production db creds
    PRODUCT_DB_CREDS = YAML.load_file(
      File.join(Rails.root, "config", "database.yml")
    )["production"]

    # log backup start time
    logger = Logger.new('./log/database_backup.log')
    logger.info "----- Database Backup Started backup_type: #{Time.now} -----"

    begin
      database = PRODUCT_DB_CREDS.fetch("database")
      password = PRODUCT_DB_CREDS.fetch("password")
      username = PRODUCT_DB_CREDS.fetch("username")
      host = PRODUCT_DB_CREDS.fetch("host")
      bucket = "eventible-database-backup"
      region = ENV.fetch('REGION')
      time = Time.zone.now
      filename = "db_backup_#{time.strftime('%Y%B%d_')}#{time.to_s(:number)}.dump"
      file_path =  "/data/#{filename}"

      backup_cmd = "PGPASSWORD=#{password} pg_dump -h #{host} "\
        "-Fc --encoding='UTF8' -v -U #{username} #{database} > #{file_path}"

      # create backup file
      system backup_cmd

      # log backup file size
      size = (File.size(file_path).to_f/1024000).round(2)
      logger.info "Filename: #{filename}, size: #{size}"

      # upload local backup file to s3
      credential = Aws::Credentials.new(
        ENV.fetch('ACCESS_KEY_ID'),
        ENV.fetch('SECRET_ACCESS_KEY')
      )
      Aws.config.update({ region: region, credentials: credential})
      s3 = Aws::S3::Resource.new(region: region)
      key = File.basename(file_path)
      s3.bucket(bucket).object(key).upload_file(file_path)

      # remove local backup file
      system "rm #{file_path}"

      # notify admin through mail
      AdminMailer.database_backup(filename, time, size).deliver

      # log backup end time
      logger.info "----- Database Backup Finished backup_type: #{Time.now} -----"
    rescue => e
      # Raise rollbar
      msg = "Data Backup failed due to #{e.message}"
      logger.error msg
      logger.error e.backtrace.join("\n")
      # Rollbar.error(e, msg)
    end
  end
end