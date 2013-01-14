require './lib/static_game_constraint'

describe StaticGameConstraint do

  let(:req) { stub }
  let(:game) { stub }
  let(:games) { stub }

  subject { described_class.new(games) }

  describe "#matches?" do

    it "matches when given an id param" do
      req.stub(params: {'id' => 'slug'})
      games.stub(:find).with('slug') { game }
      expect(subject).to be_matches(req)
    end

    it "matches when given an id param" do
      req.stub(params: {'id' => 'slug'})
      games.stub(:find).with('slug') { game }
      expect(subject).to be_matches(req)
    end

    it "fails with no matching games" do
      req.stub(params: {'id' => 'slug', 'game_id' => 'slug'})
      games.stub(:find)
      expect(subject).to_not be_matches(req)
    end

  end

end
