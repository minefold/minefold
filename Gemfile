source :rubygems

# Server
gem 'thin'

# Framework
gem 'rails', '3.1.0.rc4'

# ORM
gem 'bson_ext'
gem 'mongo_mapper',
  git: 'https://github.com/jnunemaker/mongomapper.git'

# Caching
gem 'rack-cache', require: 'rack/cache'

# Templates
gem 'haml'
gem 'sass-rails'
gem 'jquery-rails'

# Auth
gem 'devise'
gem 'mm-devise', require: false

# Payment
gem 'activemerchant'

# Other
gem 'stringex'
gem 'high_voltage'
gem 's3_swf_upload',
  git: 'https://github.com/nathancolgate/s3-swf-upload-plugin'
gem 'resque'
gem 'fog'
gem 'gravtastic'

group :development do
  gem 'heroku'
  gem 'foreman'
  gem 'rake'
end

group :test do
  gem 'turn', require: false
end

group :production do
  gem 'dalli'
end
