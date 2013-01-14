require './lib/game'

describe Game do

  subject { described_class.new(
    id: 1,
    name: 'Name',
    slug: 'slug'
  )}

  [:auth?, :routable?, :mappable?].each do |method|
    it "#{method} defaults to false" do
      expect(subject.send(method)).to be(false)
    end
  end

  it "#to_param is the slug" do
    expect(subject.to_param).to eq('slug')
  end

end
