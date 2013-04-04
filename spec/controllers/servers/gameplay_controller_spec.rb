require 'spec_helper'

describe Servers::GameplayController do

  let(:server) { Server.make! }

  it "PUT #update authenticates user" do
    put :update, server_id: server.id
    expect(response).to authenticate_user
  end
  
  it "restarts the server if requested" do
    sign_in(server.creator)
    PartyCloud.should_receive(:stop_server).with(server.party_cloud_id)
    put :update, id: server.id, restart: true
  end

end
