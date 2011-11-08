require 'spec_helper'

describe UsersController do
  render_views
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe '#create' do
    before do
      post :create, user: { username: 'notch', email: 'notch@mojang.com', password: 'rainycorn' }
    end
    
    it "should redirect to new world" do
      response.should redirect_to(new_world_path)
    end
    
    it "creates a user" do
      User.by_username('notch').should_not be_empty
    end
  end

end
