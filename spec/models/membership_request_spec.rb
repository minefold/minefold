require 'spec_helper'

describe MembershipRequest do
  let(:world) {create(:world)}
  let(:current_user) {create(:user)}

  it {should be_embedded_in(:world)}
  it {should belong_to(:user)}

  it "makes the user a member of the world" do
    mr = world.membership_requests.new user: current_user
    mr.approve

    world.members.should include(current_user)
  end

end
