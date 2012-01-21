require 'spec_helper'

describe World do
  let(:world) {build(:world)}

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

  describe 'before_create' do
    context 'with referenced world_upload' do
      let(:world) { create :world, world_upload: WorldUpload.new(world_data_file: 'uploaded') }
      subject { world }
      
      its(:world_data_file) { should == 'uploaded' }
    end
  end

  it "changes the slug when changing the name" do
    lambda {
      world.name = world.name.reverse
      world.save
    }.should change(world, :slug)
  end
  
  describe 'clone_world' do
    let(:cloner) { build :user }
    subject { world.clone_world cloner }
    
    its(:parent) { should == world }
    its(:world_data_file) { should == world.world_data_file }
  end
end
