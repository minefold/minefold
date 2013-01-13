require 'spec_helper'

describe Servers::WatchersController do
  setup_devise_mapping(:user)

  let(:server) { Server.make! }
  let(:user) { User.make! }

  describe "POST #create" do

    it "authenticates users" do
      post :create, server_id: server.id
      expect(response).to authenticate_user
    end

    it "adds the user to the server's watchers" do
      sign_in(user)
      expect {
        post :create, server_id: server.id
      }.to change { server.watchers.include?(user) }.from(false).to(true)
    end

  end

  describe "POST #destroy" do

    it "authenticates users" do
      post :create, server_id: server.id
      expect(response).to authenticate_user
    end

    it "removes the user from the server's watchers" do
      sign_in(user)
      server.watchers << user
      expect {
        post :destroy, server_id: server.id
      }.to change { server.watchers.include?(user) }.from(true).to(false)
    end

  end

end
