require 'test_helper'

class Worlds::UploadsControllerTest < ActionController::TestCase

  setup_devise_mapping(:user)

  test "post create unauthenticated" do
    post :create
    assert_unauthenticated_response
  end

  test "post create" do
    user = Fabricate(:user)
    sign_in(user)

    post :create
    assert_response :success
  end

# ---

  # TODO Not sure why this is failing with 401 unauthorized
  test "get policy unauthenticated" do
    get :policy, format: :xml
    assert_unauthenticated_response
  end

  test "get policy" do
    user = Fabricate(:user)
    sign_in(user)

    get :policy, format: :xml
    assert_response :success
  end

end
