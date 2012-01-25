require 'spec_helper'

describe ProcessChatJob do
  let(:world) { Fabricate(:world) }

  it "should create chat event" do
    subject.process! world, world.creator, 'oh hai!'

    World.find(world.id).events.first.text.should == 'oh hai!'
  end
end
