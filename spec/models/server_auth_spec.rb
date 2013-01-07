require 'spec_helper'

describe ServerAuth do
  let(:server) { Server.new }
  subject { ServerAuth.new(server) }

  describe "#setup?" do
    it "is false" do
      expect(subject).to_not be_setup
    end
  end


  describe "#can_play?" do
    let(:user) { User.new }

    it "is true" do
      expect(subject.can_play?(user)).to be_true
    end
  end

end
