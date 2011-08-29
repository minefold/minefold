require 'spec_helper'

describe CreditEvent do
  it {should have_field(:delta)}
  it {should be_embedded_in(:user)}
end
