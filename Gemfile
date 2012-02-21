source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rake'
gem 'thin'
gem 'rails'
gem 'sprockets'

gem 'rack-www'

# ORM
gem 'mongoid', '2.4.3'
gem 'bson_ext'
gem 'mongoid_slug'

# Authentication
gem 'devise'
gem 'cancan'
gem 'omniauth-facebook'

# Payment Processing
gem 'stripe'

# Notifications
gem 'pusher'

# Views
gem 'haml'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails', '0.5.3.1'
gem 'coffee-filter'
gem 'decent_exposure'
gem 'rabl', '>=0.5'
gem 'kaminari'

gem 'asset_sync'

# Uploads
gem 'carrierwave', git: 'https://github.com/jnicklas/carrierwave.git'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'mini_magick'

# Job Processing
gem 'resque', require: ['resque', 'resque/server']

gem 'resque_mailer'

# Logs & Stats
gem 'exceptional'
gem 'statsd-instrument'
gem 'rpm_contrib'
gem 'newrelic_rpm'
gem 'em-mixpanel'

# Mail
gem 'createsend'

group :development, :test do
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
  gem 'resque-exceptional'
  gem 'nbtfile'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'faker'
  gem 'fabrication'
  gem 'mongoid-rspec'
  gem 'autotest-rails'
  gem 'database_cleaner'
  gem 'capybara', '~> 1.1.1'
  gem 'timecop'
end
