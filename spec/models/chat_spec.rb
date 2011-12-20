require 'spec_helper'

describe Chat do
  it { should have_field(:text) }

  let(:user) { build :user, username: 'douche' }
  subject { Chat.new source: user, text: 'all the things!' }
  
  its(:msg) { should == '<douche> all the things!' }
end
