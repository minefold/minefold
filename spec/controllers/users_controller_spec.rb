require 'spec_helper'

describe UsersController do
  render_views

  describe '#create' do
    remap_devise!

    before(:each) {
      post :create, user: {
        username: 'notch',
        email: 'notch@mojang.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    subject { response }
    it { should redirect_to(user_root_path) }

    it "creates a user" do
      User.by_username('notch').should exist
    end
  end
end
