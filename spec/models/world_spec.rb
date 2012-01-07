require 'spec_helper'

describe World do
  let(:world) {create(:world)}

  it { should be_timestamped_document }

  it { should have_field(:name)}
  it { should have_field(:slug)}

  it { should have_field(:seed).with_default_value_of('')}
  it { should have_field(:pvp).with_default_value_of(true)}
  it { should have_field(:spawn_monsters).with_default_value_of(true)}
  it { should have_field(:spawn_animals).with_default_value_of(true)}

  it { should belong_to(:creator).of_type(User).as_inverse_of(:created_worlds)}

  it { should reference_many(:events)}

  it { should validate_presence_of(:name)}
  it { should embed_many(:memberships) }


  it "changes the slug when changing the name" do
    lambda {
      world.name = world.name.reverse
      world.save
    }.should change(world, :slug)
  end
end
