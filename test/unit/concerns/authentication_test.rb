require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase

  test ".find_for_database_authentication" do
    user = User.make!
    assert_equal user,
      User.find_for_database_authentication(email_or_username: user.username)

    assert_equal user,
      User.find_for_database_authentication(email_or_username: user.email)

    assert !User.find_for_database_authentication(email_or_username: 'blerg')
    assert !User.find_for_database_authentication(email_or_username: 'blerg@example.com')
  end

  test ".new_with_session" do
    user = User.new_with_session({}, {
      'devise.facebook_data' => {'extra' => {'raw_info' => {
        'first_name' => 'Chris'
      }}}
    })

    assert_equal 'Chris', user.first_name
  end

  test ".new_with_session sets Mixpanel distinct_id" do
    user = User.new_with_session({email: 'chris@example.com'}, {
      'distinct_id' => 'foobar'
    })

    assert_equal 'foobar', user.distinct_id
  end

  test ".new_with_session doesn't override existing data" do
    user = User.new_with_session({email: 'chris@example.com'}, {
      'devise.facebook_data' => {'extra' => {'raw_info' => {
        'username' => 'chrsllyd',
        'email' => 'blah@facebook.com'
      }}}
    })

    # Tests that it overrides blank values
    assert_equal 'chrsllyd', user.username
    assert_equal 'chris@example.com', user.email
  end

end
