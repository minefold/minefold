source 'http://rubygems.org'

gem 'rails', '3.1.0.rc8'
gem 'thin'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'mongoid'
gem 'bson_ext'
gem 'devise',
  git: 'https://github.com/plataformatec/devise.git'
gem 'em-http-request'

gem 'sendgrid'
gem 'activemerchant'
gem 'pusher'

gem 'statsd-instrument'

gem 'mongoid_slug'
gem 'gravtastic'
gem 'high_voltage'
gem 'decent_exposure'

gem 'resque', require: 'resque/server'
gem 'resque_mailer'

gem 'haml'
gem 'mustache'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails'

group :worker do
  gem 'fog'
  gem 'rinku'
  gem 'embedly'
end

group :development do
  gem 'heroku'
  gem 'foreman'
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'mongoid-rspec'
end
