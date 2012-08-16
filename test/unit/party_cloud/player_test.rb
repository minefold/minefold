require 'test_helper'

class PartyCloud::PlayerTest < ActiveSupport::TestCase

  test "is backed by Mongo" do
    assert PartyCloud::Player.included_modules.include?(Mongoid::Document)
  end

end
