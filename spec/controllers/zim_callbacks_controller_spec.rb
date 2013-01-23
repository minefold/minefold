require 'spec_helper'

def raw_post(action, params, body)
  @request.env['RAW_POST_DATA'] = body
  response = post(action, params)
  @request.env.delete('RAW_POST_DATA')
  response
end

describe ZimCallbacksController do
  let(:server) { Server.make!(world: World.make!) }

  describe "POST #map_deleted" do
    it "deletes world" do
      payload = {
        id: server.id,
        date: Time.now.to_i
      }

      raw_post :map_deleted, {}, payload.to_json

      assigns(:server).reload.world.should be_nil
    end
  end
end