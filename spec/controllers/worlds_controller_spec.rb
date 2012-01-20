require 'spec_helper'

describe WorldsController do
  render_views

  let(:world) { create(:world)}

  describe "#show" do
    it "renders" do
      get :show, user_id: world.creator.slug, id: world.slug
      response.should be_successful
    end

    context 'creator' do
      signin_as { world.creator }

      it "shows link to settings" do
        get :show, user_id: world.creator.slug, id: world.slug
        response.body.should include(edit_user_world_path(world.creator, world))
      end
    end
  end
  
  describe '#clone' do
    
  end
end
