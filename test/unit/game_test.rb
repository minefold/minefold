require 'test_helper'

class GameTest < ActiveSupport::TestCase
  
  test "#minecraft?" do
    assert Game.make(:minecraft).minecraft?
    assert !Game.make.minecraft?
  end
  
end
