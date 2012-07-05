require 'test_helper'

class Worlds::MembershipsControllerTest < ActionController::TestCase

  test "get index" do
    world = Fabricate(:world)

    get :index, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

# ---

  test "post create unauthenticated" do
    world = Fabricate(:world)

    post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_unauthenticated_response
  end

  test "post create unauthorized" do
    world = Fabricate(:world)
    user = Fabricate(:user)
    sign_in(user)

    post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_unauthorized_response
  end

  test "post create" do
    world = Fabricate(:world)
    sign_in(world.creator)

    post :create, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

# ---

  pending "delete destroy unauthenticated"

  pending "delete destroy unauthorized"

  test "delete destroy" do
    world = Fabricate(:world)

    delete :destroy, player_id: world.creator.minecraft_player.slug, world_id: world.slug
    assert_response :success
  end

end
