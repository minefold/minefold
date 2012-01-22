require 'spec_helper'

describe MembershipRequest do
  let(:world) { Fabricate(:world) }
  let(:user) { Fabricate(:user) }
  subject { world.membership_requests.new(user: user) }

  specify { be_embedded_in(:world) }

  specify { belong_to(:user) }
  specify { validate_presence_of(:user) }

  describe "#approve" do
    it "adds the user as a member of the world" do
      subject.approve
      world.members.should include(subject.user)
    end
  end
end
