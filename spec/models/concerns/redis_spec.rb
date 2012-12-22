require 'spec_helper'

describe Concerns::Redis do

  class TestSubject
    include Concerns::Redis
  end

  subject {
    TestSubject.new
  }

  context "ClassMethods" do

    subject {
      TestSubject
    }

    describe ".redis_id" do
      it 'returns a redisable id' do
        expect(subject.redis_id(1)).to eq('1')
      end
    end

    describe ".redis_key" do
      it "returns a redis key for an id" do
        expect(subject.redis_key(1)).to eq('testsubject:1')
      end
    end

  end

  describe "#redis_key" do
    it "returns a key for the object" do
      stub(subject).id { 10 }
      expect(subject.redis_key).to eq('testsubject:10')
    end
  end

end
