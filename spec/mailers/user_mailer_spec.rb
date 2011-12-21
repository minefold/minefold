require "spec_helper"

describe UserMailer do
  describe "reminder" do
    let(:user) { create :user }
    let(:mail) { UserMailer.reminder user.id }
    
    it "renders the headers" do
      mail.subject.should eq("Buy more Minefold time (running low)")
      mail.to.should eq([user.email])
    end

    it "renders the body" do
      mail.body.encoded.should include(user.username)
      mail.body.encoded.should include(time_account_url)
    end
  end
end
