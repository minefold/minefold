require 'spec_helper'

describe PlayersController do
  render_views
  
  let(:user)  { create :user }
  let(:world) { create :world, creator: user }
  
  describe '#index' do
    it "should succeed" do
      get :index, user_id: user.slug, world_id: world.slug
      response.should be_success
    end
  end
  
  describe '#ask' do
    it "should redirect to world" do
      post :ask, world_id: world.slug
      response.should redirect_to(world_path(world))
    end
  end

  describe '#add' do
    it "should redirect to world" do
      post :add, world_id: world.slug, player_id: user.id
      response.should redirect_to(edit_world_path(world, anchor: 'players'))
    end
  end

  describe '#destroy' do
    before do
      world.whitelisted_players << user
      world.save!
    end

    it "should redirect to world" do
      delete :destroy, world_id: world.slug, id: user.slug
      response.should redirect_to(edit_world_path(world, anchor: 'players'))
    end
  end
end