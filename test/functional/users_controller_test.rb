require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup_devise_mapping(:user)

  test "GET #show" do
    user = User.make!
    get :show, id: user.slug
    assert_response :success
  end

  test "PUT #update" do
    user = User.make!
    put :update, id: user.id
    assert_unauthenticated_response
  end

  test "PUT #update unauthorized" do
    user = User.make!
    punk = User.make!

    sign_in(punk)

    put :update, id: user.id
    assert_unauthorized_response
  end

  test "PUT #update authenticated" do
    user = User.make!
    sign_in(user)

    assert user.username != 'test', 'username precondition failed'

    put :update, id: user.id, user: { username: 'test' }
    assert_redirected_to user_root_path

    user.reload
    assert_equal user.username, 'test'
  end

end
