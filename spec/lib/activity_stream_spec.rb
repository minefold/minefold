require './lib/activity_stream'

describe ActivityStream do

  let(:model) { stub(id: 123) }
  let(:redis) { stub }

  subject { described_class.new(model, redis) }

  it "#key is a RedisKey" do
    expect(subject.key).to be_a(RedisKey)
  end

  describe "#add" do

    it "saves the activity in redis" do
      model = stub(id: 1, score: 5)
      redis.should_receive(:zadd)
        .with('activitystream:r_spec/mocks/mock:123', 5, 1)
      subject.add(model)
    end

  end

end
