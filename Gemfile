source 'http://rubygems.org'

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
gem 'devise',
  git: 'https://github.com/plataformatec/devise.git'
gem 'em-http-request'

gem 'sendgrid'
gem 'mail_view',
  git: 'https://github.com/37signals/mail_view.git'

gem 'activemerchant'
gem 'pusher'

gem 'statsd-instrument'

gem 'mongoid_slug'
gem 'gravtastic'
gem 'high_voltage'
gem 'decent_exposure'

gem 'fog'
gem 'resque', require: 'resque/server'
gem 'resque_mailer'

gem 'haml'
gem 'mustache'
gem 'bourbon',
  git: 'https://github.com/thoughtbot/bourbon.git'
gem 'jquery-rails'
gem 'backbone-rails'

group :worker do
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
