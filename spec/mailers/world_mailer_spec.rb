require "spec_helper"

describe WorldMailer do

  describe "#membership_created" do
    let(:world) { Fabricate(:world) }
    let(:membership) {
      world.memberships.create(user: Fabricate(:user))
    }

    subject {
      WorldMailer.membership_created(world.id, membership.id)
    }

    its(:to) { should include(membership.user.email) }

    its(:body) { should include(membership.user.username) }
    its(:body) { should include(membership.user.host) }
    its(:body) { should include(world.creator.username) }
    its(:body) { should include(world.name) }
    its(:body) { should include(player_world_url(world.creator.minecraft_player, world)) }
  end


  describe "#membership_request_created" do
    let(:world) { Fabricate(:world) }
    let(:membership_request) {
      world.membership_requests.create(user: Fabricate(:user))
    }

    subject {
      WorldMailer.membership_request_created(world.id, membership_request.id, world.creator.id)
    }

    its(:to) { should include(world.creator.email) }

    its(:subject) { should include(membership_request.user.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
    its(:body) { should include(membership_request.user.username) }
  end

  describe "#membership_request_approved" do
    let(:world) { Fabricate(:world) }
    let(:user) { Fabricate(:user) }

    subject {
      WorldMailer.membership_request_approved(world.id, user.id)
    }

    its(:to) {should include(user.email)}

    its(:subject) { should include(world.creator.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(user.username) }
    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
  end

  describe "#world_started" do
    let(:members) { [Fabricate(:user), Fabricate(:user)] }
    let(:players) { [Fabricate(:user), Fabricate(:user)] }

    let(:user) { members.first }

    let(:world) do
      w = Fabricate(:world, creator: players.first)
      w.stub(:members) { players + members }
      w.stub(:player_ids) { players.pluck(:id) }
      w.events.create source: players.first, text: 'come mine with me!'
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
