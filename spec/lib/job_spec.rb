require './lib/job'

describe Job do

  it "defaults the queue to low" do
    expect(described_class.queue).to eq(:low)
  end

  it "performs by default" do
    expect(subject).to be_performable
  end

  describe "#perform" do

    it "does the dirty work" do
      subject.stub(:perform!) { 'result' }
      expect(subject.perform!).to eq('result')
    end

    it "short circuits if the job isn't performable" do
      subject.stub(:performable?) { false }
      subject.stub(:perform!) { 'result' }

      expect(subject.perform).to_not eq('result')
    end

  end

end
