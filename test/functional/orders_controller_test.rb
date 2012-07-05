require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  test "unauthenticated post create" do
    post :create
    assert_unauthenticated_response
  end

  # test "post create" do
  #   sign_in @user
  #   post :create
  #   assert_response :success
  # end

end
