require 'test_helper'

class ServersControllerTest < ActionController::TestCase

  test "GET #index unauthenticated" do
    get :index
    assert_unauthenticated_response
  end

  test "GET #index" do
    user = User.make!
    sign_in(user)

    get :index
    assert_response :success
  end

  test "GET #edit unauthenticated" do
    server = Server.make!

    get :edit, id: server.id
    assert_unauthenticated_response
  end

  test "GET #edit unauthorized" do
    user = User.make!
    server = Server.make!
    sign_in(user)

    get :edit, id: server.id
    assert_unauthorized_response
  end

  test "PUT #start unauthenticated" do
    server = Server.make!

    put :start, id: server.id, ttl: 60
    assert_unauthenticated_response
  end

  test "PUT #start unauthorized" do
    server = Server.make!

    put :start, id: server.id, ttl: 60
    assert_unauthenticated_response
  end

end
