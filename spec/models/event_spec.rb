require 'spec_helper'

describe Event do
  it {should be_timestamped_document}

  it {should be_embedded_in(:wall)}
  it {should belong_to(:user).of_type(User) }
end
