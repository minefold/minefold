shared_examples_for "transactional emails" do

  describe "#subject" do

    it "includes Minefold" do
      expect(subject.subject).to include('Minefold')
    end

    it "is less than 50 characters" do
      expect(subject.subject.size).to be <= 50
    end

  end

end
