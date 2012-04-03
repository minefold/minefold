require 'spec_helper'

describe World do
  let(:world) { Fabricate.build(:world) }
  subject { world }


  it { should be_timestamped_document }
  it { should be_paranoid_document }


# ---
# Name


  it { should have_field(:name).of_type(String) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:creator_id) }


# ---
# Slug


  it { should have_field(:slug).of_type(String) }
  it { should validate_presence_of(:slug) }
  it { should validate_format_of(:slug).with_format(/^[a-z0-9_]+$/) }
  it { should validate_uniqueness_of(:slug).scoped_to(:creator_id) }
  it { should validate_length_of(:slug).within(1..20) }


# ---
# Creator


  # TODO


# ---
# Cover Photo


  # TODO


# ---
# Cloning


  # TODO


# ---
# Data


  # TODO


# ---
# Maps


  # TODO


# ---
# Players


  it {
    should have_and_belong_to_many(:opped_players)
      .as_inverse_of(nil)
      .of_type(MinecraftPlayer)
  }

  it {
    should have_and_belong_to_many(:whitelisted_players)
      .as_inverse_of(nil)
      .of_type(MinecraftPlayer)
  }

  it {
    should have_and_belong_to_many(:blacklisted_players)
      .of_type(MinecraftPlayer)
      .as_inverse_of(nil)
  }

  it '#players' do
    op = Fabricate(:minecraft_player)
    player = Fabricate(:minecraft_player)

    world.players.should be_empty

    world.whitelisted_players.push(player)
    world.players.should include(player)

    world.opped_players.push(op)
    world.players.should include(op)

    world.whitelisted_players.push(op)
    world.players.size.should == 2
  end


# ---
# Events


  # TODO


# ---
# Settings


  # TODO


# ---
# Comments


  # TODO


# ---
# Stats


  # it { should have_field(:name) }
  # it { should have_field(:slug) }
  # it { should validate_presence_of(:name) }
  #
  # it { should belong_to(:creator).of_type(User).as_inverse_of(:created_worlds) }
  # it { should validate_presence_of(:creator) }
  #
  #
  # it { should embed_many(:memberships) }
  #
  # it { should embed_many(:membership_requests) }
  #
  # it { should have_field(:seed) }
  # it { should have_field(:pvp).with_default_value_of(true) }
  # it { should have_field(:spawn_monsters).with_default_value_of(true) }
  # it { should have_field(:spawn_animals).with_default_value_of(true) }
  #
  # it { should reference_many(:events) }
  #
  # describe 'before_create' do
  #   context 'with referenced world_upload' do
  #     let(:upload) { Fabricate(:world_upload) }
  #     let(:world) { Fabricate(:world, world_upload_id: upload.id) }
  #     subject { world.reload }
  #
  #     its(:world_data_file) { should == upload.world_data_file }
  #   end
  # end
  #
  # it "changes the slug when changing the name" do
  #   lambda {
  #     subject.name = subject.name.reverse
  #     subject.save
  #   }.should change(subject, :slug)
  # end
  #
  # it "generates a random seed based on the time (like Minecraft)" do
  #   Timecop.freeze do
  #     world.seed.should == Time.now.to_i.to_s
  #   end
  # end

  describe 'clone_world' do
    subject { world.clone! }
  
    its(:parent) { should == world }
    its(:world_data_file) { should == world.world_data_file }
    its(:map_data) { should == world.map_data }
    
    its(:game_mode) { should == world.game_mode }
    its(:level_type) { should == world.level_type }
    its(:seed) { should == world.seed }
    its(:difficulty) { should == world.difficulty }
    its(:pvp) { should == world.pvp }
    its(:spawn_monsters) { should == world.spawn_monsters }
    its(:spawn_animals) { should == world.spawn_animals }
    its(:generate_structures) { should == world.generate_structures }
    its(:spawn_npcs) { should == world.spawn_npcs }
  end

  # describe "#creator=" do
  #   it "makes the creator an op" do
  #     world.ops.should include(world.creator)
  #   end
  # end
  #
  # describe "#add_member" do
  #   let(:member) { Fabricate(:user) }
  #
  #   it "sets the created_at dates correctly" do
  #     membership = subject.add_member(member)
  #     subject.save
  #
  #     membership.should_not be_new_record
  #     membership.created_at.should_not be_nil
  #   end
  # end
  #
  # describe '#delete' do
  #   let(:world) { Fabricate :world }
  #   let(:member) { Fabricate :user, current_world: world }
  #
  #   before {
  #     member.current_world.should == world
  #     world.delete!
  #     member.reload
  #   }
  #
  #   it "should set members's current_worlds's to nil" do
  #     member.current_world.should be_nil
  #   end
  # end
end
