require 'spec_helper'

describe Activity do

  describe ".publish" do

    it "creates an activity" do
      subject.should_receive(:save)
      described_class.stub(:for).with('a', 'b', 'c') { subject }
      described_class.publish('a', 'b', 'c')
    end

    it "passes any args to .for" do
      subject.stub(:save)
      described_class.should_receive(:for)
        .with('a', 'b', 'c') { subject }
      described_class.publish('a', 'b', 'c')
    end

  end

  describe "#score" do

    it 'is 0 by default' do
      expect(subject.score).to eq(0)
    end

    it 'is the created_at time as an integer' do
      subject.created_at = Time.at(10)
      expect(subject.score).to eq(10)
    end

  end

  describe "#interested" do
    let(:model) { User.new }

    it "returns an empty list" do
      expect(subject.interested).to eq([])
    end

  end

  describe "#publish_to" do

    it "adds itself to each interested ActivityStream" do
      # stream = stub.should_receive(:add).with(subject)
      stream = stub(:add => 'tracer')
      ActivityStream.stub(new: stream)
      subject.publish_to(stub).should == 'tracer'
    end

  end

  describe "#publish_to_target" do
    it "adds itself to the target's ActivityStream" do
      subject.stub(target: stub)
      subject.should_receive(:publish_to).with(subject.target)
      subject.publish_to_target
    end
  end

  describe "#broadcast" do
    it "publishes itself to each interested object" do
      user = stub
      subject.should_receive(:publish_to).with(user)
      subject.stub(:interested) { [user] }
      subject.broadcast
    end
  end

end
