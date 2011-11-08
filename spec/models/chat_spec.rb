require 'spec_helper'

describe Chat do
  it {should be_a(WallItem)}

  it {should have_field(:raw)}
  it {should have_field(:html)}

  it "#body should be html or raw" do
    chat = Chat.new
    chat.body.should be_nil
    chat.raw = 'foo'
    chat.body.should == 'foo'

    chat.html = '<p>foo</p>'
    chat.body.should == '<p>foo</p>'
  end

end
