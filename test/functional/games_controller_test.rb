require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  test "GET #show" do
    game = Game.make!
    get :show, id: game.id
    assert_response :success
  end

end
