require 'spec_helper'

describe Webhooks::ZimController do
  let(:server) { Server.make!(world: World.make!) }

  describe "POST #map_deleted" do
    it "deletes world" do
      payload = {
        id: server.id,
        date: Time.now.to_i
      }

      raw_post :create, {}, payload.to_json

      assigns(:server).reload.world.should be_nil
    end
  end

end
