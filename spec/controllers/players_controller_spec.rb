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
end