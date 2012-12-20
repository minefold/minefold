source 'https://code.stripe.com'
source 'https://rubygems.org'

ruby '1.9.3'

gem 'thin'
gem 'rails', '3.2.9'
gem 'rake'
# Explicitly requiring Nokogiri *before* pg stops the stupid dylib load errors on Mountain Lion: https://github.com/sparklemotion/nokogiri/issues/742
# Can't question our commitment to Sparkle Motion!
gem 'nokogiri'
gem 'pg'
gem 'rack-www'
gem 'devise'
gem 'uniquify', git: 'https://github.com/chrislloyd/uniquify.git'
gem 'cancan'
gem 'omniauth-facebook'
gem 'stripe'
gem 'pusher'
gem 'haml'
gem 'decent_exposure', '2.0.0.rc1'
gem 'kaminari'
gem 'mini_magick'
gem 'redis'
gem 'redis-namespace'
gem 'resque', require: ['resque', 'resque/server']
gem 'resque_mailer'
gem 'resque-scheduler', require: ['resque_scheduler', 'resque_scheduler/server']
gem 'intercom'
gem 'mailgun-rails'
gem 'jbuilder'
gem 'fog'
gem 'rest-client'
gem 'bugsnag'
gem 'friendly_id'
gem 'librato-rails'
gem 'paranoia'
gem 'carrierwave'
gem 'flipper', git: 'https://github.com/chrislloyd/flipper.git'
gem 'flipper-redis', git: 'https://github.com/chrislloyd/flipper-redis.git'
gem 'sass-rails'
gem 'bourbon'
gem 'sitemap_generator'
gem 'charlock_holmes',
  git: 'https://github.com/brianmario/charlock_holmes.git',
  branch: 'bundle-icu'
gem 'html-pipeline'

group :test, :development do
  gem 'rspec-rails'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'rr'

  gem 'machinist'
  gem 'faker'
  gem 'timecop'
  gem 'fakeweb'
  gem 'simplecov'

  gem 'autotest-standalone'
end

group :worker do
  gem 'rubyzip'
  gem 'nbtfile'
end

group :assets do
  gem 'coffee-rails'
  gem 'jquery-rails'
  gem 'rails-backbone'
  gem 'uglifier'
end

