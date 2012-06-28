require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  # TODO Check wether this is really needed
  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "get new" do
    get :new
    assert_response :success
  end

  test "get edit" do
    get :edit
    assert_response :success
  end

end
