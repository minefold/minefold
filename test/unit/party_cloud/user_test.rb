require 'test_helper'

class PartyCloud::UserTest < ActiveSupport::TestCase

  test "is backed by Mongo" do
    assert PartyCloud::User.included_modules.include?(Mongoid::Document)
  end

end
