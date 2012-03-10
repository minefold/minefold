require 'spec_helper'

describe MinecraftAccount do

  it { should belong_to(:user) }


# ---
# Identity


  it { should have_field(:username) }
  it { should validate_length_of(:username).within(1..16) }
  it { should validate_uniqueness_of(:username) }

  it { should have_field(:slug) }

  it "sets the slug when setting the username" do
    subject.username = 'Foobar_baz'
    subject.slug.should == 'foobar_baz'
  end

  it "isn't valid if the username is reserved" do
    subject.class.stub(:blacklist).and_return(['reserved'])
    subject.username = 'reserved'
    subject.should_not be_valid
  end


# ---
# Unlocking


  it { should have_field(:unlock_code) }

  it "has a random unlock code" do
    subject.unlock_code.should_not be_empty
  end

  it "is unlocked when a user is associated with it" do
    subject.should_not be_unlocked
    subject.user = Fabricate(:user)
    subject.should be_unlocked
  end


# ---
# Stats


  it { should have_field(:ticks).of_type(Integer).with_default_value_of(0) }

end
