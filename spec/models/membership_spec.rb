require 'spec_helper'

describe Membership do

  it {should be_embedded_in(:world)}
  it {should belong_to(:user)}
  it {should have_field(:role)}

end
