require 'spec_helper'

describe Activity do

  describe ".publish" do

    it "creates an activity" do
      mock(subject).save
      stub(described_class).for('a', 'b', 'c') { subject }

      described_class.publish('a', 'b', 'c')
    end

    it "passes any args to .for" do
      stub(subject).save
      mock(described_class).for('a', 'b', 'c') { subject }

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
      any_instance_of(ActivityStream) do |as|
        mock(as).add(subject)
      end

      subject.publish_to(User.new)
    end

  end

  describe "#publish_to_target" do
    it "adds itself to the target's ActivityStream" do
      any_instance_of(ActivityStream) do |as|
        mock(as).add(subject)
      end

      stub(subject).target { User.new }

      subject.publish_to(User.new)
    end
  end

  describe "#broadcast" do
    it "publishes itself to each interested object" do
      user = User.new
      mock(subject).publish_to(user)
      stub(subject).interested { [user] }

      subject.broadcast
    end
  end

end
