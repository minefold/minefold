require 'spec_helper'

describe Bonuses::ReferredFriend do
  let(:referrer) { User.make! }

  subject {
    Bonuses::ReferredFriend.create(
      user: referrer,
      email: 'my_buddy@friends.org'
    )
  }

  describe 'from email' do
    before { subject.reload }
    its(:email) { should == 'my_buddy@friends.org' }
    its(:state) { should == Bonuses::ReferredFriend::States[:sent] }
  end
  
end