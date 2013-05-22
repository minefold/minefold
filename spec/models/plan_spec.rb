require 'spec_helper'

describe Plan do
  subject { Plan.make!(stripe_id: 'silver', name: 'Silver', cents: 2499, bolts: 2) }

  its(:stripe_id) { should == 'silver' }
  its(:name) { should == 'Silver' }
  its(:cents) { should == 2499 }
  its(:bolts) { should == 2 }
end