require 'test_helper'

class WorldsControllerTest < ActionController::TestCase

  test "get index" do
    get :index
    assert_response :success
  end

# ---

  test "get new unauthenticated" do
    get :new
    assert_unauthenticated_response
  end

  # TODO Fails because of redirecting to a FunPack
  test "get new" do
    user = Fabricate(:user)
    sign_in(user)

    get :new
    assert_response :success
  end

# ---

  test "post create" do
    post :create
    assert_response :redirect
  end

# ---

  test "get show" do
    world = Fabricate(:world)

    get :show, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :success
  end

# ---

  test "get edit unauthenticated" do
    world = Fabricate(:world)

    get :edit, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthenticated_response
  end

  test "get edit unauthorized" do
    world = Fabricate(:world)
    user = Fabricate(:user)
    sign_in(user)

    get :edit, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthorized_response
  end

  test "get edit" do
    world = Fabricate(:world)
    sign_in(world.creator)

    get :edit, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :success
  end

# ---

  test "put update" do
    world = Fabricate(:world)

    put :update, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :redirect
  end

# ---

  test "delete destroy unauthenticated" do
    world = Fabricate(:world)

    delete :destroy, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthenticated_response
  end

  test "delete destroy unauthorized" do
    world = Fabricate(:world)
    user = Fabricate(:user)
    sign_in(user)

    delete :destroy, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthorized_response
  end

  test "delete destroy" do
    world = Fabricate(:world)
    sign_in(world.creator)

    delete :destroy, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :redirect
  end

# ---

  test "post clone" do
    world = Fabricate(:world)

    post :clone, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :redirect
  end

# ---

  test "get invite unauthenticated" do
    world = Fabricate(:world)

    get :invite, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthenticated_response
  end

  test "get invite unauthorized" do
    world = Fabricate(:world)
    user = Fabricate(:user)
    sign_in(user)

    get :invite, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_unauthorized_response
  end

  test "get invite" do
    world = Fabricate(:world)
    sign_in(world.creator)

    get :invite, player_id: world.creator.minecraft_player.slug, id: world.slug
    assert_response :success
  end

end
