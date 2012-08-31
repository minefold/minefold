require 'test_helper'

class PusherControllerTest < ActionController::TestCase
  setup_devise_mapping :user

  test "GET #auth unauthorized" do
    get :auth
    assert_response 403
  end

  test "GET #auth authorized" do
    user = User.make!
    sign_in user

    any_instance_of(Pusher::Channel) do |ch|
      mock(ch).authenticate('socket', user_id: user.id.to_s) do
        {status: 'ok'}
      end
    end

    get :auth, socket_id: 'socket'

    assert_response :success
  end

end
