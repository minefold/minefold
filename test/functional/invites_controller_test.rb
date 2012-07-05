require 'test_helper'

class InvitesControllerTest < ActionController::TestCase

  # TODO Needs to be implemented
  test "post create unauthenticated" do
    skip 'not implemented'

    post :create
    assert_unauthenticated_response
  end

  test "post create" do
    user = Fabricate(:user)
    sign_in(user)

    post :create, invite: {facebook_uid: '1234'}
    assert_response :success
  end

end
