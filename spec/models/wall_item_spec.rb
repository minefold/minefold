require 'spec_helper'

describe WallItem do
  it {should be_timestamped_document}

  it {should be_embedded_in(:wall)}
  # it {should belong_to(:user)}
end
