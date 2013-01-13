require './lib/redis_key'

describe RedisKey do

  describe "#to_s" do

    it "generates nice keys for classes" do
      subject = described_class.new(described_class)
      expect(subject.to_s).to eq("redis_key")
    end

    it "generates nice keys for objects" do
      subject = described_class.new(stub(id: 2))
      expect(subject.to_s).to eq("r_spec/mocks/mock:2")
    end

    it "generates composite keys" do
      foo = described_class.new('foo')
      subject = described_class.new(foo, :bar)
      expect(subject.to_s).to eq("foo:bar")
    end

    it "postfixes keys" do
      subject = described_class.new(described_class, :id)
      expect(subject.to_s).to eq("redis_key:id")
    end

    it "prefixes keys" do
      subject = described_class.new(:stream, described_class)
      expect(subject.to_s).to eq("stream:redis_key")
    end

  end

end
