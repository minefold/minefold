require 'spec_helper'

describe ServerAuths::MinecraftPrivate do

  let(:funpack) { Funpack.make! }
  let(:account) { Accounts::Mojang.make! }
  let(:user) { account.user }
  let(:server) { Server.make!(creator: user, funpack_id: funpack.id) }

  subject { described_class.new(server) }

  describe "#setup" do
    before { subject.setup }

    it "creates the whitelist" do
      expect(server.settings['whitelist']).to_not be_nil
    end

    it "creates the ops list" do
      expect(server.settings['whitelist']).to_not be_nil
    end

    it "adds the creator to the list of ops" do
      expect(server.settings['ops']).to include(account.uid)
    end

  end

  describe "#persist" do
    let!(:chrislloyd) { Accounts::Mojang.make!(uid: 'chrislloyd') }
    let!(:whatupdave) { Accounts::Mojang.make!(uid: 'whatupdave') }
    let!(:yarrcat) { Accounts::Mojang.make!(uid: 'yarrcat') }

    it "adds new members" do
      stub(server).settings do
        {
          "whitelist" => "whatupdave",
          "ops"       => "chrislloyd"
        }
      end

      expect {
        subject.persist
      }.to change(server.memberships, :length).from(0).to(2)

      expect(server.members).to include(chrislloyd.user)
      expect(server.members).to include(whatupdave.user)
    end

    it "removes members" do
      server.members << whatupdave.user
      server.members << chrislloyd.user

      stub(server).settings do
        {
          "whitelist" => "",
          "ops"       => "chrislloyd"
        }
      end

      expect {
        subject.persist
      }.to change(server.memberships, :length).from(2).to(1)

      expect(server.members).to include(chrislloyd.user)
      expect(server.members).to_not include(whatupdave.user)
    end

  end

end
