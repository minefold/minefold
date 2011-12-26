source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rake'
gem 'thin'
gem 'rails'
gem 'sprockets'

# ORM
gem 'mongoid'
gem 'bson_ext'
gem 'mongoid_slug'

gem 'rack-www'

# Authentication
gem 'devise'

# Payment Processing
gem 'stripe'

# Notifications
gem 'sendgrid'
gem 'twitter'
gem 'pusher'

# Views
gem 'haml'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails'
gem 'coffee-filter'
gem 'decent_exposure'
gem 'representative', require: 'representative/json'
gem 'representative_view'

gem 'asset_sync'

# Uploads
gem 'carrierwave'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'mini_magick'

# Job Processing
gem 'resque', ' ~> 1.19.0'
gem 'resque_mailer'

# Logs & Stats
gem 'airbrake'
gem 'statsd-instrument'
gem 'rpm_contrib'
gem 'newrelic_rpm'
gem 'em-mixpanel'

group :development do
  gem 'letter_opener'
  gem 'heroku'
  gem 'foreman'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :worker do
  gem 'rubyzip'
  gem 'fog'  
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
  gem 'autotest-rails'
  gem 'database_cleaner'
  gem 'capybara', '~> 1.1.1'
  gem 'timecop'
end
