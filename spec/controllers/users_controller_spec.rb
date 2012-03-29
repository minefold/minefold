require 'spec_helper'

describe UsersController do
  render_views

  describe '#create' do
    remap_devise!

    before(:each) {
      post :create, user: {
        email: 'notch@mojang.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    subject { response }
    it { should redirect_to(verify_user_path) }

    it "creates a user" do
      User.where(email: 'notch@mojang.com').should exist
    end
  end

  context 'signed in' do
    signin_as { Fabricate(:user) }

    describe '#update' do
      context 'changing a notification setting' do
        before {
          put :update, user: { notifications: { world_started: false } }
        }

        subject { current_user.reload }

        its(:notifications) { should == { 'world_started' => false } }
      end
    end
  end

end
