require "spec_helper"

describe UserMailer do
  let(:user) { Fabricate(:user) }

  describe "welcome" do
    subject { UserMailer.welcome(user.id) }

    its(:to) { should include(user.email) }
    it { subject.html_part.body.should include('Thanks') }
  end

  describe "credit_reminder" do
    subject { UserMailer.credit_reminder(user.id) }

    its(:to) { should include(user.email) }

    # it { subject.html_part.body.should include(user.username) }
    it { subject.body.should include(user.username) }

    # it { subject.html_part.body.should include(pro_account_url) }
    it { subject.body.should include(pro_account_url) }
  end

  describe "credit_reset" do
    subject { UserMailer.credit_reset(user.id) }

    its(:to) { should include(user.email) }

    # it { subject.html_part.body.should include(user.username) }
    it { subject.body.should include(user.username) }

    # it { subject.html_part.body.should include(pro_account_url) }
    it { subject.body.should include(pro_account_url) }
  end


  describe "#membership_created" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }

    subject {
      UserMailer.membership_created(user.id, world.id, world.creator.id)
    }

    its(:to) {should include(user.email)}

    its(:subject) { should include(world.creator.username) }
    its(:subject) { should include(world.name) }

    # it { subject.html_part.body.should include(user.username) }
    it { subject.body.should include(user.username) }

    # it { subject.html_part.body.should include(world.creator.username) }
    it { subject.body.should include(world.creator.username) }

    # it { subject.html_part.body.should include(world.host) }
    it { subject.body.should include(world.host) }
  end

  describe "#membership_request_created" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }
    let(:membership_request) {
      world.membership_requests.create(minecraft_player: user.minecraft_player)
    }

    subject {
      UserMailer.membership_request_created(world.creator.id, world.id, membership_request.id)
    }

    its(:to) { should include(world.creator.email) }

    its(:subject) { should include(membership_request.player.username) }
    its(:subject) { should include(world.name) }

    # it { subject.html_part.body.should include(world.name) }
    it { subject.body.should include(world.name) }

    # it { subject.html_part.body.should include(world.slug) }
    it { subject.body.should include(world.slug) }

    # it { subject.html_part.body.should include(membership_request.player.username) }
    it { subject.body.should include(membership_request.player.username) }
  end

  describe "#membership_request_approved" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }

    subject {
      UserMailer.membership_request_approved(user.id, world.id, world.creator.id)
    }

    its(:to) {should include(user.email)}

    its(:subject) { should include(world.creator.username) }

    # it { subject.html_part.body.should include(user.username) }
    it { subject.body.should include(user.username) }

    # it { subject.html_part.body.should include(world.name) }
    it { subject.body.should include(world.name) }

    # it { subject.html_part.body.should include(world.slug) }
    it { subject.body.should include(world.slug) }
  end

  describe "#world_started" do
    let(:offline_players) { [Fabricate(:user), Fabricate(:user)] }
    let(:online_players)  { [Fabricate(:user), Fabricate(:user)] }

    let(:user) { offline_players.first }

    let(:world) do
      w = Fabricate(:world, creator: offline_players.first)
      w.stub(:player_ids) { offline_players.map(&:id) + online_players.map(&:id) }
      w.stub(:online_players) { online_players }
      w
    end

    subject { UserMailer.world_started(user.id, world.id) }

    its(:to) { should include(user.email) }

    # it { subject.html_part.body.should include(world.name) }
    it { subject.body.should include(world.name) }

    # it { subject.html_part.body.should include(player_world_url(world.creator.minecraft_player, world)) }
    it { subject.body.should include(world.host) }

    # it { subject.html_part.body.should include(user.username) }
    it { subject.body.should include(user.username) }
  end
end
