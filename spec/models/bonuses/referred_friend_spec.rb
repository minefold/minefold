require 'spec_helper'

describe Bonuses::ReferredFriend do
  let(:referrer) { User.make! }

  describe 'from email' do
    subject {
      Bonuses::ReferredFriend.new(
        user: referrer,
        email: 'my_buddy@friends.org'
      )
    }

    its(:email) { should == 'my_buddy@friends.org' }
    its(:state) { should == Bonuses::ReferredFriend::States[:sent] }
  end
end