require 'test_helper'

class Worlds::MembershipRequestsControllerTest < ActionController::TestCase

  test "post create" do
    world = Fabricate(:world)

    post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

  test "put approve" do
    world = Fabricate(:world)

    put :approve, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

  test "delete destroy" do
    world = Fabricate(:world)

    delete :destroy, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

end
