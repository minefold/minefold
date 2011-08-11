require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # test "invite is generated before validation" do
  #   user = User.new
  #   assert !user.invite.present?
  #   user.valid?
  #   assert user.invite.present?
  # end

  # test "invite is the right length" do
  #   user = User.new
  #   user.set_invite
  #   assert_equal user.invite.length, User::TOKEN_LENGTH
  # end


  test "downcases #email when saving" do
    email = 'Foo@Bar.com'
    user = User.new :email => email
    assert_equal user.email, email

    user.save
    assert_equal user.email, 'foo@bar.com'
  end

  test "downcases #email before validation" do
    User.create :email => 'Foo@Bar.com'
    assert !User.new(:email => 'foo@bar.com').valid?
  end

  test "removes whitespace from #email when saving" do
    email = ' foo@bar.com '
    user = User.new :email => email
    assert_equal user.email, email

    user.save
    assert_equal user.email, 'foo@bar.com'
  end

  test "generates encrypted password when setting password" do
    user = User.new
    assert !user.encrypted_password.present?

    user.password = 'foo'
    assert user.encrypted_password.present?
  end

  test "re-encrypts password if it changes" do
    user = User.new email: 'foo@bar.com'
    user.password = user.password_confirmation = 'foo'

    encrypted_password = user.encrypted_password

    user.password = user.password_confirmation = 'bar'
    assert_not_equal user.encrypted_password, encrypted_password
  end

  test "checking password" do
    user = User.new
    user.password = user.password_confirmation = 'foo'

    assert user.password == 'foo'
    assert user.password != 'bar'
  end

  test "doesn't raise error with empty password" do
    user = User.new
    assert_nothing_raised { user.password == 'foo'}
    assert_not_equal user.password, 'foo'
  end
end
