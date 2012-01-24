require 'spec_helper'

describe World do
  let(:world) { Fabricate.build(:world) }
  subject { world }

  specify { be_timestamped_document }

  specify { have_field(:name) }
  specify { have_field(:slug) }
  specify { validate_presence_of(:name) }

  specify { belong_to(:creator).of_type(User).as_inverse_of(:created_worlds) }
  specify { validate_presence_of(:creator) }


  specify { embed_many(:memberships) }

  specify { embed_many(:membership_requests) }

  specify { have_field(:seed).with_default_value_of('') }
  specify { have_field(:pvp).with_default_value_of(true) }
  specify { have_field(:spawn_monsters).with_default_value_of(true) }
  specify { have_field(:spawn_animals).with_default_value_of(true) }

  specify { reference_many(:events) }

  context 'with referenced world_upload' do
    let(:world_upload) { WorldUpload.new(world_data_file: 'uploaded')}
    subject { Fabricate(:world, world_upload: world_upload) }

    its(:filename) { should == 'uploaded' }
  end

  it "changes the slug when changing the name" do
    lambda {
      subject.name = subject.name.reverse
      subject.save
    }.should change(subject, :slug)
  end

  describe 'clone_world' do
    let(:user) { Fabricate(:user) }
    subject {
      world.map_data = { zoomLevels: 16 }
      world.clone!.tap do |clone|
        clone.creator = user
      end
    }

    specify(:parent) { eq world }
    specify(:filename) { eq world.filename }
    its(:map_data) { should == { zoomLevels: 16 } }
  end

  describe "#creator=" do
    it "makes the creator an op" do
      world.ops.should include(world.creator)
    end
  end

  describe "#add_member" do
    let(:member) { Fabricate(:user) }

    it "sets the created_at dates correctly" do
      membership = world.add_member(member)
      world.save

      membership.should_not be_new_record
      membership.created_at.should_not be_nil
    end
  end
end
