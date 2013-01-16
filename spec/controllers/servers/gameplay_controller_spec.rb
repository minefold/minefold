require 'spec_helper'

describe Servers::GameplayController do

  let(:server) { Server.make! }

  it "PUT #update authenticates user" do
    put :update, server_id: server.id
    expect(response).to authenticate_user
  end

end
