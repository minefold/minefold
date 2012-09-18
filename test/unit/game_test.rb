require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "#minecraft?" do
    assert Game.make(:minecraft).minecraft?
    assert !Game.make.minecraft?
  end
  
end
