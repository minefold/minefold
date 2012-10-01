require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  %w(home about support pricing jobs privacy terms).each do |page|
    test "GET ##{page}" do
      minecraft = Game.make!(:minecraft)
      
      get page
      assert_response :success
    end
  end

end
