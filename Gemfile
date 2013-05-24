source 'https://code.stripe.com'
source 'https://rubygems.org'

ruby '2.0.0'

gem 'puma'
gem 'rails', '>= 3.2.11'
gem 'rake'
# Explicitly requiring Nokogiri *before* pg stops the stupid dylib load errors on Mountain Lion: https://github.com/sparklemotion/nokogiri/issues/742
# Can't question our commitment to Sparkle Motion!
gem 'nokogiri', '~> 1.5'
gem 'html-pipeline'
gem 'pg'
gem 'postgres_ext'
gem 'rack-www'
gem 'devise'
gem 'uniquify',
  github: 'chrislloyd/uniquify'
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
gem 'resque',
  require: ['resque', 'resque/server']
gem 'resque_mailer'
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
gem 'flipper'
gem 'flipper-redis'
gem 'sass-rails'
gem 'bourbon'
gem 'sitemap_generator'
gem 'lograge'
gem 'memcachier'
gem 'dalli'
gem 'scrolls'
gem 'rest-client'
gem 'state_machine', require: 'state_machine/core'
gem 'omniauth-steam', require: ['omniauth-openid', 'omniauth-steam']

gem 'activerecord-postgres-hstore',
  github: 'softa/activerecord-postgres-hstore'
gem 'postgres_ext'

gem 'eco'
gem 'analytics-ruby'

gem 'brock', github: 'minefold/brock', branch: 'master'

group :test, :development do
  gem 'rspec-rails'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'machinist'
  gem 'faker'
  gem 'timecop'
  gem 'webmock'
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

