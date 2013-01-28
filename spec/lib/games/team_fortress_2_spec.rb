require './lib/games/team_fortress_2'

describe TeamFortress2 do

  subject { described_class.new(
    id: 1, name: 'Team Fortress 2', slug: 'tf2'
  )}

  [:auth?, :static_address?, :mappable?].each do |attr|
    it "##{attr} is false" do
      expect(subject.send(attr)).to be_false
    end
  end

end
