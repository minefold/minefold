require 'spec_helper'

describe TimePack do

  let(:pack) { subject.class.new('beta-3m-1500', 3.months, 1500) }

  it '#dollars' do
    pack.dollars.should == 15.0
  end

end
