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

    it "returns a list" do
      expect(subject.interested).to be_an(Array)
    end

    it "returns a list with the actor" do
      subject.actor = model
      expect(subject.interested).to include(model)
    end

    it "returns a list with the target" do
      subject.target = model
      expect(subject.interested).to include(model)
    end

  end

  describe "#publish" do

    it "adds itself to each interested ActivityStream" do
      any_instance_of(ActivityStream) do |as|
        mock(as).add(subject)
      end

      stub(subject).interested { [User.new] }

      subject.publish
    end

  end

end
