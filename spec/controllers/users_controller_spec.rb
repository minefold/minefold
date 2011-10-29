require 'spec_helper'

describe UsersController do
  render_views
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe '#create' do
    it "creates a user" do
      post :create, user: { username: 'notch', email: 'notch@mojang.com', password: 'rainycorn' }
      
      assigns(:user).username.should == 'notch'
    end
    
    context 'with an invite code' do
      
    end
  end

end
