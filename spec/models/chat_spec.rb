require 'spec_helper'

describe Chat do
  let(:user) { Fabricate.build(:user, username: 'whatupdave') }
  subject { Fabricate.build(:chat, source: user, text: 'all the things!') }

  it { should have_field(:text) }

  its(:msg) { eq '<whatupdave> all the things!' }
end
