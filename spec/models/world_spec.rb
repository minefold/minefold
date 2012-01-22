require 'spec_helper'

describe World do
  subject { Fabricate.build(:world) }

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

  it "changes the slug when changing the name" do
    lambda {
      subject.name = subject.name.reverse
      subject.save
    }.should change(subject, :slug)
  end

  it "doesn't duplicate memberships"
  it "ads the creator as an op when setting the creator"
end
