require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:creator) { create :user }
  let(:world)   { create :world, creator: creator }

  let(:user) { create :user }

  context 'signed in' do
    # describe '#ask' do
    #   let(:current_user) {create :user}
    #   signin_user
    #
    #   it "should redirect to world" do
    #     post :ask, world_id: world.slug
    #     response.should redirect_to(world_path(world))
    #   end
    # end

    # describe '#add' do
    #   let(:current_user)  { world.memberships << Membership.new(role: 'op', user: creator); creator }
    #
    #   before do
    #     @request.env["devise.mapping"] = Devise.mappings[:user]
    #     sign_in current_user
    #   end
    #
    #   it "should redirect to world" do
    #     post :add, world_id: world.slug, id: applicant.id
    #     response.should redirect_to(world_path(world))
    #   end
    # end
  end



end
