require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup_devise_mapping(:user)

  test "inherits from Devise::RegistrationsController" do
    assert_equal Devise::RegistrationsController,
      RegistrationsController.superclass
  end
  
  test "#after_sign_up_path_for" do
    user = User.make!
    
    assert_equal onboard_users_path,
      @controller.after_sign_up_path_for(user)
  end
  
end
