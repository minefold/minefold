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
gem 'rails_warden',
  git: 'https://github.com/hassox/rails_warden.git'
gem 'bcrypt-ruby', require: 'bcrypt'

# Other
gem 'stringex'
gem 'decent_exposure'

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
