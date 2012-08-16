require 'test_helper'

class PartyCloud::WorldTest < ActiveSupport::TestCase

  test "is backed by Mongo" do
    assert PartyCloud::World.included_modules.include?(Mongoid::Document)
  end

end
