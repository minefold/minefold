require "spec_helper"

describe UserMailer do
  let(:user) { create :user }

  describe "reminder" do
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

  describe "welcome" do
    let(:mail) { UserMailer.welcome user.id }
    
    it "renders the headers" do
      mail.subject.should include('Welcome')
      mail.to.should eq([user.email])
    end

    it "renders the body" do
      mail.body.encoded.should include(user.username)
      mail.body.encoded.should include('10 hours free')
    end
  end
end
