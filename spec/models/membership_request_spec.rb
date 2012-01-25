require 'spec_helper'

describe MembershipRequest do
  let(:world) { Fabricate(:world) }
  let(:user) { Fabricate(:user) }
  subject { world.membership_requests.new(user: user) }

  it { should be_embedded_in(:world) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  describe "#approve" do
    it "adds the user as a member of the world" do
      subject.approve
      world.members.should include(subject.user)
    end
  end
end
