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

  describe '#join' do
    let(:member) { Fabricate(:user) }
    let(:world) { Fabricate(:world) }

    context 'public' do
      before { post :join, user_id: world.creator.slug, id: world.slug }
      it "is unauthorized"
    end

    context 'member' do
      before {
        @request.env['devise.mapping'] = Devise.mappings[:user]

        world.add_member(member)
        world.save!

        sign_in member

        post :join, user_id: world.creator.slug, id: world.slug
      }

      subject { response }

      it { should redirect_to(user_world_path(world.creator, world)) }

      it "sets the user's current world" do
        member.reload
        member.current_world.should == world
      end
    end

    context 'already joined' do
      signin_as { Fabricate(:user, current_world: world) }
      before { world.add_member(current_user) }

      it "does nothing" do
        lambda {
          post :join, user_id: world.creator.slug, id: world.slug
        }.should_not change(current_user, :current_world)
      end
    end
  end

  describe '#clone' do
    let(:world) { Fabricate(:world) }
    signin_as { Fabricate(:user) }

    before {
      post :clone, user_id: world.creator.slug, id: world.slug
    }

    subject { response }

    it { should redirect_to(user_world_path(current_user, world.slug)) }
  end
end
