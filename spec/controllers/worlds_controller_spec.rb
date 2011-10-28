require 'spec_helper'

describe WorldsController do
  render_views
  
  let(:user)  { create :user }
  let(:world) { create :world, creator: user }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    
    world.wall_items.push Chat.new(raw: 'wasssuuuuuuuup', creator: user)
  end
  
  describe '#show' do
    it "should succeed" do
      get :show, user_id: user.slug, id: world.slug
    
      response.should be_success
    end
  end

  # describe "create" do
  #   let(:world) {build(:world)}
  # 
  #   it "redirects to the world's page" do
  #     post :create, world: {name: world.name}
  # 
  #     assigns[:world].should_not be_nil
  # 
  #     response.should be_redirect
  #     response.should redirect_to(user_world_path(@world.creator, @world))
  #   end
  # 
  #   it "sets the user's current world" do
  #     user.reload
  #     user.current_world.should == assigns[:world]
  #   end
  # end
end