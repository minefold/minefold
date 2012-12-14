require 'spec_helper'

describe ActivityStream do

  let(:model) {
    m = Object.new
    stub(m).redis_key { 'model:123' }
    m
  }

  describe "#key" do
    subject {
      described_class.new(model, nil)
    }

    it "prefixes the model's #redis_key" do
      expect(subject.key).to start_with('activitystream')
    end

    it "is a full key" do
      expect(subject.key).to eq("activitystream:model:123")
    end

  end

  describe "#add" do
    let(:activity) {
      a = Object.new
      stub(a) {
        id { 1 }
        score { 5 }
      }
      a
    }

    it "calls Redis' zadd" do
      redis = Object.new
      mock(redis).zadd('activitystream:model:123', 5, 1)

      described_class.new(model, redis).add(activity)
    end

  end


end
