source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rake'
gem 'thin'
gem 'rails'
gem 'sprockets'

gem 'rack-www'
gem 'uuid'

# ORM
gem 'mongo', '~>1.5'
gem 'mongoid', git: 'https://github.com/mongoid/mongoid.git', ref: 'e5a6f2f841ba7ab32fe5e16039381d744ab27842'
gem 'bson_ext'

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
gem 'backbone-rails'
gem 'coffee-filter'
gem 'decent_exposure'
gem 'rabl', '>=0.5'
gem 'kaminari'
gem 'rdiscount'

# Uploads
gem 'carrierwave', git: 'https://github.com/jnicklas/carrierwave.git'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'mini_magick'

# Job Processing
gem 'resque', require: ['resque', 'resque/server']
gem 'resque_mailer'
gem 'fog'

# Logs & Stats
gem 'exceptional'
gem 'statsd-instrument'
gem 'rpm_contrib'
gem 'newrelic_rpm'
gem 'em-mixpanel', git: 'https://github.com/minefold/em-mixpanel'
gem 'intercom'

# Mail
gem 'createsend'
gem 'mailgun-rails'
gem 'premailer'
gem 'premailer-rails3'
gem 'mail_view'

group :development, :test do
  gem 'heroku'
  gem 'foreman'

  gem 'letter_opener'
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
  gem 'resque-exceptional'
  gem 'nbtfile'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'faker'
  gem 'fog'

  gem 'fabrication'
  gem 'mongoid-rspec', git: 'https://github.com/angelim/mongoid-rspec.git',
                       branch: 'mongoid-3.0-support'
  gem 'autotest-rails'
  gem 'database_cleaner'
  gem 'capybara', '~> 1.1.1'
  gem 'timecop'
end
