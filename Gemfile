source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'devise'
# For API versioning
gem 'versionist'
# For JWT token based api authentication
gem 'jwt'
# ENV variable handling
gem 'dotenv-rails', require: 'dotenv/rails-now'
# Background processing using sidekiq
gem 'sidekiq'
# Apitome is a API documentation tool for Rails built on top of the great rspec DSL included in rspec_api_documentation
gem 'apitome'
gem "sprockets", "<4"
gem 'rack', '~> 2.0.8'
gem "httparty"
gem "trailblazer", github: 'trailblazer/trailblazer', tag: 'v2.1.0.rc1'
gem "trailblazer-rails", github: 'trailblazer/trailblazer-rails', tag: 'v2.1.5'
gem "pundit"
gem "reform", '2.2.4'
gem 'cache_crispies', '~> 1.1', '>= 1.1.2'
gem 'rollbar'
#Downloading remote file
gem "down", "~> 5.0"
gem "builder"
gem 'spreadsheet'
gem 'roo'
gem 'hubspot-api-client'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'carrierwave-aws'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'aws-sdk-rails'

# Blazing fast application deployment tool.
gem 'mina', '~> 1.2', '>= 1.2.3'
gem 'mina-puma', require: false,  github: 'untitledkingdom/mina-puma'
gem 'devise_invitable', '~> 2.0.0'
gem 'multi_logger'
gem 'mailchimp_api_v3'
gem 'gemoji'

group :development, :test do
  # Generate pretty API docs for your Rails APIs.
  gem 'rspec_api_documentation'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'rspec-rails'
  # For identifying N+1 qierries
  gem 'bullet'
  # Brakeman is an open source static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  gem 'brakeman', require: false
  # The Listen gem listens to file modifications and notifies you about the changes.
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'overcommit'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
end

group :test do
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'codeclimate-test-reporter'
  gem 'webmock'
  # Database Cleaner is a set of strategies for cleaning your database in Ruby.Used while running tests
  gem 'database_cleaner-active_record'
  # A library for setting up Ruby objects as test data.
  gem 'factory_bot_rails'
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "audited", "~> 4.9"
gem "friendly_id", "~> 5.4.0"
gem 'aws-sdk', '~> 3.1'
gem 'whenever', require: false
gem 'newrelic_rpm'
# gem 'lamby'
