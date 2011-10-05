source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'thin'
gem 'rails', '3.1.0'

# ORM
gem 'mongoid', git: 'https://github.com/pyromaniac/mongoid.git'
gem 'bson_ext'
gem 'mongoid_slug'

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

# Pages
gem 'high_voltage'

# Views
gem 'haml'
gem 'mustache'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails'
gem 'coffee-filter'
gem 'decent_exposure', git: 'https://github.com/chrislloyd/decent_exposure.git'

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
  gem 'spork', '~> 0.9.0.rc'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'mongoid-rspec'
end
