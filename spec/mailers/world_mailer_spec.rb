require "spec_helper"

describe WorldMailer do
  describe "play_request" do
    let(:owner)     { create :user }
    let(:world)     { create :world, creator: owner }
    let(:requestor) { create :user }
    
    let(:mail)      { WorldMailer.play_request world.id, requestor.id }

    it "renders the headers" do
      mail.subject.should eq("#{requestor.username} would like to play in #{world.name}")
      mail.to.should eq([owner.email])
    end

    it "renders the body" do
      mail.body.encoded.should include(world.name)
      mail.body.encoded.should include(world.slug)
      mail.body.encoded.should include(requestor.username)
    end
  end

end
