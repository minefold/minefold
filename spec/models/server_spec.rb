require 'spec_helper'

describe Server do
  describe "#add_creator_to_watchers" do
    it "is called on create" do
      creator = User.make!
      server = Server.make!(creator: creator)

      expect(server.watchers).to include(creator)
    end
  end

  describe '#allocate_shared_host!' do
    it "sets host" do
      server = Server.make!
      server.allocate_shared_host!
      server.host.should == "#{server.id}.fun-#{server.funpack.id}.us-east-1.foldserver.com"
    end
  end
end
