require 'spec_helper'

describe World do

  it { should be_timestamped_document }

  it { should have_field(:name)}
  it { should have_field(:slug)}

  it { should have_field(:seed).with_default_value_of('')}
  it { should have_field(:pvp).with_default_value_of(true)}
  it { should have_field(:spawn_monsters).with_default_value_of(true)}
  it { should have_field(:spawn_animals).with_default_value_of(true)}

  it { should belong_to(:creator).of_type(User).as_inverse_of(:created_worlds)}

  it { should reference_and_be_referenced_in_many(:whitelisted_players).of_type(User)}

  it { should embed_many(:wall_items)}


# VALIDATIONS

  it { should validate_presence_of(:name)}



end
