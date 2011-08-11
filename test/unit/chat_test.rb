require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  test "process! linkifies raw" do
    chat = Chat.new raw:'check out http://i.imgur.com/I2juO.png thing'
    
    chat.process!
    
    assert_equal 'check out <a href="http://i.imgur.com/I2juO.png">http://i.imgur.com/I2juO.png</a> thing', chat.html
  end

  test "process! should query links for media types" do
    chat = Chat.new raw:'check out http://i.imgur.com/I2juO.png thing'
    
    chat.process!
    
    assert_equal 1, chat.media.size
  end
  
  
end
