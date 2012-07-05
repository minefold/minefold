require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup_devise_mapping(:user)


  test "get new" do
    get :new
    assert_response :success
  end

  test "post create" do
    post :create
    assert_response :success
  end

# ---

  test "get edit unauthenticated" do
    get :edit
    assert_unauthenticated_response
  end

  test "get edit" do
    user = Fabricate(:user)
    sign_in(user)

    get :edit
    assert_response :success
  end

# ---

  test "put update unauthenticated" do
    put :update
    assert_unauthenticated_response
  end

  test "put update" do
    user = Fabricate(:user)
    sign_in(user)

    put :update
    assert_response :success
  end

# ---

  test "get dashboard unauthenticated" do
    get :dashboard
    assert_unauthenticated_response
  end

  test "get dashboard" do
    user = Fabricate(:user)
    sign_in(user)

    get :dashboard
    assert_response :success
  end

# ---

  test "get unlink_player" do
    put :unlink_player
    assert_response :success
  end

# ---

  test "get verify unauthenticated" do
    get :verify
    assert_unauthenticated_response
  end

  test "get verify" do
    user = Fabricate(:user)
    sign_in(:user)

    get :verify
    assert_response :success
  end

end
