require './lib/job'

describe Job do

  it "defaults the queue to low" do
    expect(described_class.queue).to eq(:low)
  end

  describe ".perform" do

    it "initializes a new object" do
      subject.stub(:perform) { 'result' }
      described_class.stub(new: subject)
      expect(described_class.perform).to eq('result')
    end

    it "calls #perform on the new instance" do
      subclass = Class.new(described_class) do
        def perform
          'sentinal'
        end
      end
      expect(subclass.perform).to eq('sentinal')
    end

    it "raises an error if #perform is false" do
      subject.stub(:perform) { false }
      described_class.stub(new: subject)
      expect {
        described_class.perform
      }.to raise_error(Job::JobFailed)
    end

  end

end
