require 'spec_helper'

describe Server do
  let(:creator) { User.make! }

  describe "#add_creator_to_watchers" do
    let(:server) { Server.make!(creator: creator) }

    it "is called on create" do
      expect(server.watchers).to include(creator)
    end

  end
end
