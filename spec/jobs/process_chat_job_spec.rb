require 'spec_helper'

describe ProcessChatJob do
  let(:world) { Fabricate(:world) }

  it "should create chat event" do
    ProcessChatJob.perform world.id, world.creator.username, 'oh hai!'

    World.find(world.id).events.first.text.should == 'oh hai!'
  end
end
