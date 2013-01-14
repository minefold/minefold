require './lib/game_library'

describe GameLibrary do
  let(:game) { stub(id: 1, slug: 'slug') }

  it "can have games added to it" do
    subject.push(game)
    expect(subject).to include(game)
  end

  it "can fetch games by their id" do
    subject.push(game)
    expect(subject.fetch(1)).to eq(game)
  end

  it "can find games by their id" do
    subject.push(game)
    expect(subject.find('slug')).to eq(game)
  end

end
