require "spec_helper"

describe WorldMailer do

  describe "#membership_created" do
    let(:creator) { create(:user) }
    let(:world) { create(:world, creator: creator) }

    let(:membership) {
      world.memberships.create(user: create(:user))
    }

    subject {
      WorldMailer.membership_created(world.id, membership.id)
    }

    its(:to) { should include(membership.user.email) }

    its(:subject) { should include(world.name) }

    its(:body) { should include(membership.user.username) }
    its(:body) { should include(membership.user.host) }
    its(:body) { should include(creator.username) }
    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
  end


  describe "#membership_request_created" do
    let(:creator) { create(:user) }
    let(:world) { create(:world, creator: creator) }

    let(:membership_request) {
      world.membership_requests.create(user: create(:user))
    }

    subject {
      WorldMailer.membership_request_created(world.id, membership_request.id)
    }

    its(:to) { should include(creator.email) }

    its(:subject) { should include(membership_request.user.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
    its(:body) { should include(membership_request.user.username) }
  end

  describe "#membership_request_approved" do
    let(:creator) { create(:user) }
    let(:world) { create(:world, creator: creator) }
    let(:user) { create(:user) }

    subject {
      WorldMailer.membership_request_approved(world.id, user.id)
    }

    its(:to) {should include(user.email)}

    its(:subject) { should include(creator.username) }
    its(:subject) { should include(world.name) }

    its(:body) { should include(user.username) }
    its(:body) { should include(world.name) }
    its(:body) { should include(world.slug) }
  end

  describe "#world_started" do
    let(:members) { [create(:user), create(:user)] }
    let(:players) { [create(:user), create(:user)] }

    let(:user) { members.first }

    let(:world) do
      w = create :world, creator: players.first
      w.stub(:members) { players + members }
      w.stub(:player_ids) { players.pluck(:id) }
      w.events.create source: players.first, text: 'come mine with me!'
      w
    end

    subject { WorldMailer.world_started(world.id, user.id) }

    it "renders the headers" do
      subject.subject.should include(world.name)
      subject.to.should include(user.email)
    end

    it "renders the body" do
      subject.body.encoded.should include(world.name)
      subject.body.encoded.should include(world.slug)
      subject.body.encoded.should include(user.username)
    end
  end


end
