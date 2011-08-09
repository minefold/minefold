source :rubygems

gem 'thin'
gem 'rails', '~> 3.1.0.rc'

gem 'bson_ext'
gem 'mongo_mapper',
  git: 'https://github.com/jnunemaker/mongomapper.git'

gem 'devise'
gem 'mm-devise', require: false

gem 'activemerchant'
gem 'stringex'
gem 'high_voltage'
gem 's3_swf_upload',
  git: 'https://github.com/nathancolgate/s3-swf-upload-plugin'

gem 'resque', require: 'resque/server'
gem 'fog'
gem 'gravtastic', '>= 3.2.4', groups: [:default, :assets]
gem 'em-http-request'
gem 'pusher'
gem 'sendgrid'

group :assets, :development do
  gem 'sass-rails'
  gem 'bourbon'
  gem 'coffee-script'
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'backbone-rails'
end

gem 'haml'

group :development do
  gem 'heroku'
  gem 'foreman'
  gem 'rake'
end

group :test do
  gem 'turn', require: false
end
