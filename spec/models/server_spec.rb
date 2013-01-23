require 'spec_helper'

describe Server do

  describe "#add_creator_to_watchers" do

    it "is called on create" do
      creator = User.make!
      server = Server.make!(creator: creator)

      expect(server.watchers).to include(creator)
    end

  end

end
