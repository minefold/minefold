require './lib/games/minecraft'

describe Minecraft do

  subject { described_class.new(id: 1, name: 'Minecraft', slug: 'minecraft') }

  [:auth?, :routable?, :mappable?].each do |attr|
    it "##{attr} is true" do
      expect(subject.send(attr))
    end
  end

end
