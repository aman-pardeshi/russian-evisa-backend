if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['SECRET_ACCESS_KEY'],
      region: ENV['REGION']
    }
    config.fog_directory = ENV['BUCKET']
    config.fog_public = true 

    # config.storage    = :aws
    # config.aws_bucket = ENV.fetch('BUCKET')
    # config.aws_acl    = 'public-read'

    # Optionally define an asset host for configurations that are fronted by a
    # content host, such as CloudFront.
    # config.asset_host = "https://#{ENV.fetch('BUCKET')}.s3.amazonaws.com"

    # The maximum period for authenticated_urls is only 7 days.
    # config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching
    # config.aws_attributes = {
    #   expires: 1.week.from_now.httpdate,
    #   cache_control: 'max-age=604800'
    # }

    # config.aws_credentials = {
    #   access_key_id:     ENV.fetch('ACCESS_KEY_ID'),
    #   secret_access_key: ENV.fetch('SECRET_ACCESS_KEY'),
    #   region:            ENV.fetch('REGION') # Required
    # }
  end
end
