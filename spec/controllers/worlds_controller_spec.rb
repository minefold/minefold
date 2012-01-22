require 'spec_helper'

describe WorldsController do
  render_views

  describe "#create" do
    signin_as { Fabricate(:user) }

    before {
      post :create, world: {
        name: 'minebnb'
      }
    }

    it { response.should redirect_to(user_world_path(current_user.slug, 'minebnb')) }
  end

  describe "#show" do
    let(:world) { Fabricate(:world) }

    it "renders" do
      get :show, user_id: world.creator.slug, id: world.slug
      response.should be_successful
    end

    context 'signed in as the creator' do
      signin_as { world.creator }
    end

    context 'signed in as an op' do
      # signin_as { subject.creator }
    end

    context 'signed in as a player' do
      # signin_as { subject.creator }
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
