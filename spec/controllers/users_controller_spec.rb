require 'spec_helper'

describe UsersController do
  setup_devise_mapping(:user)


  describe "GET #show" do

    it "is successful" do
      user = User.make!
      get :show, id: user.slug
      expect(response).to be_successful
    end

  end

  # describe "PUT #update" do
  #   it_behaves_like "authenticated action"
  #
  #   it "asdf" do
  #     expect(true).to eq(true)
  #   end
  #
  # end


  # test "PUT #update" do
  #   user = User.make!
  #   put :update, id: user.id
  #   assert_unauthenticated_response
  # end
  #
  # test "PUT #update unauthorized" do
  #   user = User.make!
  #   punk = User.make!
  #
  #   sign_in(punk)
  #
  #   put :update, id: user.id
  #   assert_unauthorized_response
  # end
  #
  # test "PUT #update authenticated" do
  #   user = User.make!
  #   sign_in(user)
  #
  #   assert user.username != 'test', 'username precondition failed'
  #
  #   put :update, id: user.id, user: { username: 'test' }
  #   assert_redirected_to edit_user_registration_path
  #
  #   user.reload
  #   assert_equal user.username, 'test'
  # end

end
