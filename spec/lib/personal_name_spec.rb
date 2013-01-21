require './lib/personal_name'

describe PersonalName do

  let(:user) {
    stub(username: 'chrislloyd', first_name: nil, last_name: nil, name: nil)
  }

  subject { described_class.new(user) }

  describe "#full" do

    it "returns the first and last name if both present" do
      user.stub(first_name: 'Chris', last_name: 'Lloyd')
      expect(subject.full).to eq('Chris Lloyd')
    end

    it "returns the full name if first and last name are not present" do
      user.stub(first_name: 'Chris',name: 'King Chris')
      expect(subject.full).to eq('King Chris')
    end

    it "returns the username if no names are present" do
      stub(first_name: '', last_name: '', name: '')
      expect(subject.full).to eq('chrislloyd')
    end

    it "returns the username by default" do

      expect(subject.full).to eq('chrislloyd')
    end

  end

  describe "#first" do

    it "returns the first name if present" do
      user.stub(first_name: 'Chris')
      expect(subject.first).to eq('Chris')
    end

    it "returns the username if first name isn't present" do
      user.stub(first_name: '')
      expect(subject.first).to eq('chrislloyd')
    end

  end

end
