require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest

  test "new user signing up" do
    @user = User.create

    email, username = ['chris@minefold.com', 'chrislloyd']

    post '/signup', user: {
                      email: email,
                      username: username,
                      password: 'password',
                      password_confirmation: 'password',
                      invite: @user.invite
                    }

    assert_redirected_to dashboard_url
    follow_redirect!

    assert_template 'user/dashboard'

    @user.reload
    assert_equal @user.email, email
    assert_equal @user.username, username
  end

end
