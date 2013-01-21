shared_examples_for "transactional emails" do

  it "has Minefold in the subject" do
    expect(subject.subject).to include('Minefold')
  end

end
