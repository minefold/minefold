require 'spec_helper'

describe WorldsController do
  render_views
  
  let(:user)  { create :user }
  let(:world) { create :world, creator: user }

  before do
    world.wall_items.push Chat.new(raw: 'wasssuuuuuuuup', user: user)
  end
  
  describe '#show' do
    context 'user signed in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end
      
      it "should succeed" do
        get :show, user_id: user.slug, id: world.slug
        response.should be_success
      end
    end
    
    context 'user not signed in' do
      context 'without invite code' do
        it "should succeed" do
          get :show, user_id: user.slug, id: world.slug
          response.should be_success
        end
      end
      
      context 'with invite code' do
        it "should succeed" do
          get :show, user_id: user.slug, id: world.slug, i: 'C0D3'
          response.should be_success
        end
        
        it 'should set cookie' do
          get :show, user_id: user.slug, id: world.slug, i: 'C0D3'
          cookies['invite'].should == 'C0D3'
        end
      end
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