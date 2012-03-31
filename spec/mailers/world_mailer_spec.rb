require "spec_helper"

describe WorldMailer do

  describe "#membership_request_created" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }
    let(:membership_request) {
      world.membership_requests.create(user: user)
    }

    subject {
      WorldMailer.membership_request_created(world.id, membership_request.id, world.creator.id)
    }

    its(:to) { should include(world.creator.email) }

    its(:subject) { should include(membership_request.user.minecraft_player.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
    its(:body) { should include(membership_request.user.minecraft_player.username) }
  end

  describe "#membership_request_approved" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }

    subject {
      WorldMailer.membership_request_approved(world.id, world.creator.id, user.id)
    }

    its(:to) {should include(user.email)}

    its(:subject) { should include(world.creator.username) }

    its(:body) { should include(user.username) }
    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
  end

  describe "#membership_created" do
    let(:world) { Fabricate(:world) }
    let(:new_user) { Fabricate(:user) }

    subject {
      WorldMailer.membership_created(world.id, world.creator.id, new_user.id)
    }

    its(:to) {should include(new_user.email)}

    its(:subject) { should include(world.creator.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(new_user.minecraft_player.username) }
    its(:body) { should include(world.creator.minecraft_player.username) }
    its(:body) { should include(world.host) }
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

    subject { WorldMailer.world_started(world.id, user.id) }

    its(:to) { should include(user.email) }

    its(:body) { should include(world.name) }
    its(:body) { should include(player_world_url(world.creator.minecraft_player, world)) }
    its(:body) { should include(user.username) }
  end

  describe "#world_deleted" do
    let(:user) { Fabricate :user }

    subject { WorldMailer.world_deleted('worldy', 'worldy-creator', user.id) }

    its(:to) { should include(user.email) }

    its(:body) { should include('worldy') }
    its(:body) { should include('worldy-creator') }
  end
end
