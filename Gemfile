source 'https://code.stripe.com'
source 'https://rubygems.org'

ruby '1.9.3'

gem 'unicorn'
gem 'rails', '3.2.6'
gem 'rake'
gem 'rack-www'
gem 'devise'
gem 'cancan'
gem 'omniauth-facebook'
gem 'stripe'
gem 'pusher'
gem 'haml'
gem 'decent_exposure'
gem 'kaminari'
gem 'rdiscount'
gem 'mini_magick'
gem 'resque', require: ['resque', 'resque/server']
gem 'resque_mailer'
gem 'exceptional'
gem 'intercom'
gem 'mailgun-rails'
gem 'jbuilder'
gem 'fog'
gem 'rest-client'

# TODO KILL KILL KILL
gem 'mongoid', '3.0.0.rc'
gem 'uuid'

gem 'carrierwave', git: 'https://github.com/jnicklas/carrierwave.git'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'

group :development do
  gem 'heroku'
  gem 'foreman'
  gem 'sqlite3'
end

group :test do
  gem 'autotest-rails'
  gem 'turn'
  gem 'minitest'
  gem 'rr'
  gem 'ruby-prof'
  gem 'sqlite3'
  gem 'timecop'

  gem 'fabrication'
  gem 'faker'
end

group :production do
  gem 'pg'
end

group :worker do
  gem 'rubyzip'
  gem 'resque-exceptional'
  gem 'nbtfile'
end

group :assets do
  gem 'coffee-rails'
  gem 'jquery-rails'
  gem 'backbone-rails'
  gem 'uglifier'
end

gem 'sass-rails'
gem 'bourbon'
