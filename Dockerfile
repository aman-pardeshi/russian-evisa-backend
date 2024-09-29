FROM ruby:2.7.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the necessary gems
RUN bundle install

# Copy the entire app into the container
COPY . .

# Precompile assets if you have them
RUN bundle exec rake assets:precompile

# Expose the port that the app will run on
EXPOSE 3000

# The command to run the Rails app using Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

