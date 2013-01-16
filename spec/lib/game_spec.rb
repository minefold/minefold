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

  it "is not published if it doesn't have a publish date" do
    expect(subject).to_not be_published
  end

  it "is not published if it doesn't have a publish date" do
    subject.stub(published_at: Time.now)
    expect(subject).to be_published
  end

  it "is new it's less than 2 months old" do
    subject.stub(published_at: 1.month.ago)
    expect(subject).to be_new
  end

  it "isn't new it's more than 2 months old" do
    subject.stub(published_at: 3.months.ago)
    expect(subject).to_not be_new
  end

end
