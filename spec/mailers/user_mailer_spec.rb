require "spec_helper"

describe UserMailer do
  describe "invite" do
    let(:user)   { build :user }
    let(:world)  { build :world, creator: user}
    let(:invite) { user.invites.build email: 'chris@minefold.com', world: world }
    let(:mail)   { UserMailer.invite invite }

    it "renders the headers" do
      mail.subject.should eq("#{user.username} wants you to play in #{world.name}")
      mail.to.should eq(["chris@minefold.com"])
      mail.from.should eq(["team@minefold.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include(world.name)
      mail.body.encoded.should include(world.slug)
      mail.body.encoded.should include(user.slug)
    end
  end

end
