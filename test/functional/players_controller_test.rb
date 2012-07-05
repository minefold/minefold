require 'test_helper'

class PlayersControllerTest < ActionController::TestCase

  test "get show" do
    user = Fabricate(:user)
    get :show, id: user.minecraft_player.slug
    assert_response :success
  end

end
