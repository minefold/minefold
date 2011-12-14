source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rake', '0.9.2.2'
gem 'thin'
gem 'rails', '3.1.0'
gem 'sprockets', '2.0.2'

# ORM
gem 'mongoid'
gem 'bson_ext'
gem 'mongoid_slug'

gem 'rack-www'

# Authentication
gem 'rack-ssl'
gem 'devise'

# Payment Processing
gem 'stripe'

# Notifications
gem 'sendgrid'
gem 'twitter'
gem 'pusher'
gem 'em-http-request'

# Views
gem 'haml'
gem 'mustache'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails'
gem 'coffee-filter'
gem 'decent_exposure'
gem 'mustache'

gem 'asset_sync'

# Uploads
gem 'carrierwave'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'mini_magick'

# Job Processing
gem 'fog'
gem 'resque', require: 'resque/server'
gem 'resque_mailer'

gem 'mail_view', git: 'https://github.com/37signals/mail_view.git'

gem 'rinku'

# Logging
gem 'airbrake'
gem 'statsd-instrument'
gem 'rpm_contrib'
gem 'newrelic_rpm'

group :development do
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
  gem 'embedly'
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
