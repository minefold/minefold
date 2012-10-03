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
  
  test "GET #map" do
    server = Server.make!
    
    get :map, id: server.id
    assert_response :not_found
  end
  
  test "GET #map for Minecraft server" do
    server = Server.make!(:minecraft)
    
    get :map, id: server.id
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
  
  test "POST #start" do
    server = Server.make!
    
    mock(server).start! { true }
    
    post :start, id: server.id
    assert_response :success
  end

end
