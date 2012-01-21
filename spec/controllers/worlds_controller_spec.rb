require 'spec_helper'

describe WorldsController do
  render_views

  let(:world) { create(:world) }

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
    let(:cloner) { create :user }
    signin_as { cloner }
    
    before { post :clone, user_id: world.creator.slug, id: world.slug }
    
    context 'cloned world' do
      subject { World.where(creator_id: cloner.id, slug: world.slug).first }
      it { should_not be_nil }
    end
    
    it "should redirect to new world with same slug" do
      response.should redirect_to(user_world_path(cloner, world.slug))
    end
  end
end
