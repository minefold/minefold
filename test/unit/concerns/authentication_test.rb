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

  test ".find_or_initialize_from_facebook" do
    pending
  end

  test ".find_for_facebook_oauth with current user" do
    current_user = User.make!(facebook_uid: '1234')
    good_auth = { 'uid' => '1234' }

    assert_nil User.find_for_facebook_oauth({'uid' => 'bad_auth'}, current_user)

    assert_equal current_user,
                 User.find_for_facebook_oauth({'uid' => '1234'}, current_user)
  end

  test ".find_for_facebook_oauth" do
    user = User.make!(facebook_uid: '1234')
    auth = { 'uid' => '1234' }

    assert_nil User.find_for_facebook_oauth({'uid' => 'bad_auth'})
    assert_equal user, User.find_for_facebook_oauth({'uid' => '1234'})
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
