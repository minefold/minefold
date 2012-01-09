require 'spec_helper'

describe PlayerOppedJob do
  let(:creator) {create(:user)}
  let(:world) {create(:world)}
  let(:user) {create(:user)}

  before {
    world.add_member(user)
  }

  it "makes the player an op" do
    subject.process! world, user
    world.ops.should include(user)
  end
end
