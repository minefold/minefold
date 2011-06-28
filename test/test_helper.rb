ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # include Devise::TestHelpers

  include Warden::Test::Helpers

  setup do
    MongoMapper.database.collections.each(&:remove)
  end

  teardown do
    Warden.test_reset!
  end

end
