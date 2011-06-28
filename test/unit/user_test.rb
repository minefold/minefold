require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "invite token is generated before validation" do
    @user = User.new
    assert_nil @user.invite
    @user.valid?
    assert_not_nil @user.invite
  end

  test "invite token is the right length" do
    @user = User.new
    @user.set_invite
    assert_equal @user.invite.length, User::TOKEN_LENGTH
  end

end
