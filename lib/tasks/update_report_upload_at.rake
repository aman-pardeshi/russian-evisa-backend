namespace "update_report_upload_at" do 
  desc "updating the report uploaded at date to 1 week after event end date"
  task :update_date => :environment do 

    s3 = Aws::S3::Client.new(
      access_key_id: ENV.fetch('ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY'),
      region: ENV.fetch('REGION')
    )
    bucket_name = ENV.fetch('BUCKET')

    events = Event.where.not(analysis_report: nil).order(:id)

    events.each do |event|
      object_key = event.analysis_report.url.split(".com/").last
      response = s3.head_object(bucket: bucket_name, key: object_key)

      file_size = (response.content_length / 1.0.kilobyte).round(2)

      event.update(analysis_report_uploaded_at: event.end_date.to_datetime + 7, analysis_report_size: file_size)

      puts event.id
    end
  end
end