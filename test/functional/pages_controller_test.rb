require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  test "GET #home" do
    minecraft = Game.make!(:minecraft)
    
    get :home
    assert_response :success
  end
  
  %w(about support pricing privacy terms).each do |page|
    test "GET ##{page}" do
      get page
      assert_response :success
    end
  end

end
