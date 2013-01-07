require 'spec_helper'

describe Server do

  describe "#add_creator_to_watchers" do
    it "is called on create" do
      creator = User.make!
      server = Server.make!(creator: creator)

      expect(server.watchers).to include(creator)
    end
  end

  describe "#auth_type" do
    let(:server) { Server.new }

    it "returns the auth class" do
      expect(server.auth_type).to eq(ServerAuths::MinecraftPrivate)

      server.auth_type_enum = 1
      expect(server.auth_type).to eq(ServerAuths::MinecraftPublic)
    end
  end

  describe "#auth_type=" do
    let(:server) { Server.new }

    it "clears the auth cache" do
      expect {
        server.auth_type = ServerAuths::MinecraftPublic
      }.to change(server, :auth)
    end
  end

end
