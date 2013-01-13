require 'spec_helper'

describe ServersController do

  let(:server) { Server.make! }


  describe "PUT #update" do

    it "authenticates user" do
      put :update, id: server.id
      expect(response).to authenticate_user
    end

    it "restarts the server if requested" do
      sign_in(server.creator)
      PartyCloud.should_receive(:stop_server).with(server.party_cloud_id)
      put :update, id: server.id, restart: true
    end

  end

  # test "GET #index unauthenticated" do
  #   get :index
  #   assert_unauthenticated_response
  # end
  #
  # test "GET #index" do
  #   user = User.make!
  #   sign_in(user)
  #
  #   get :index
  #   assert_response :success
  # end
  #
  # test "GET #map" do
  #   server = Server.make!
  #
  #   get :map, id: server.id
  #   assert_response :not_found
  # end
  #
  # test "GET #map for Minecraft server" do
  #   server = Server.make!(:minecraft)
  #
  #   get :map, id: server.id
  #   assert_response :success
  # end
  #
  # test "GET #edit unauthenticated" do
  #   server = Server.make!
  #
  #   get :edit, id: server.id
  #   assert_unauthenticated_response
  # end
  #
  # test "GET #edit unauthorized" do
  #   user = User.make!
  #   server = Server.make!
  #   sign_in(user)
  #
  #   get :edit, id: server.id
  #   assert_unauthorized_response
  # end
  #
  # test "PUT #start unauthenticated" do
  #   server = Server.make!
  #
  #   put :start, id: server.id, ttl: 60
  #   assert_unauthenticated_response
  # end
  #
  # test "PUT #start unauthorized" do
  #   server = Server.make!
  #
  #   put :start, id: server.id, ttl: 60
  #   assert_unauthenticated_response
  # end

end
