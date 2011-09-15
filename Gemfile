source 'http://rubygems.org'

gem 'rake', '0.9.2'
gem 'rails', '3.1.0'
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
gem 'devise'
gem 'em-http-request'

gem 'sendgrid'

gem 'activemerchant'
gem 'pusher'

gem 'statsd-instrument'

gem 'mongoid_slug'
gem 'gravtastic'
gem 'high_voltage'
gem 'decent_exposure',
  git: 'https://github.com/chrislloyd/decent_exposure.git'

gem 'fog'
gem 'resque', require: 'resque/server'
gem 'resque_mailer'

gem 'haml'
gem 'mustache'
gem 'bourbon'
gem 'jquery-rails'
gem 'backbone-rails'
gem 'coffee-filter'

group :worker do
  gem 'rinku'
  gem 'embedly'
end

group :development do
  gem 'heroku'
  gem 'foreman'
  gem 'looksee'
  gem 'wirble'
  gem 'hirb'
end

group :test, :development do
  gem 'mail_view',
    git: 'https://github.com/37signals/mail_view.git'
end

group :test do
  gem 'spork', '~> 0.9.0.rc'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'mongoid-rspec'
end
