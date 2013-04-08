require 'spec_helper'

describe Funpack do
  subject { Funpack.make!(bolt_allocations: [512, 1024, 2048]) }
  
  its(:bolt_allocations) { should == [512, 1024, 2048] }
end
