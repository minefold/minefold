require 'test_helper'

class Servers::UploadsControllerTest < ActionController::TestCase
  setup_devise_mapping(:user)

  setup do
    ENV['AWS_ACCESS_KEY'] = 'AWS_ACCESS_KEY'
    ENV['AWS_SECRET_KEY'] = 'AWS_SECRET_KEY'
    ENV['UPLOADS_BUCKET'] = 'uploads.localhost'
  end

  teardown do
    ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY'], ENV['UPLOADS_BUCKET'] = nil
  end


  # test "post create unauthenticated" do
  #   post :create
  #   assert_unauthenticated_response
  # end
  #
  # test "post create" do
  #   user = Fabricate(:user)
  #   sign_in(user)
  #
  #   post :create
  #   assert_response :success
  # end

  # TODO Not sure why this is failing with 401 unauthorized
  test "GET #policy unauthenticated" do
    get :policy, format: :xml
    assert_unauthenticated_response
  end

  test "GET #policy" do
    user = User.make!
    sign_in(user)

    get :policy, format: :xml
    assert_response :success
  end

end
