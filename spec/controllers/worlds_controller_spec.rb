require 'spec_helper'

describe WorldsController do
  let(:dave) { User.create username: 'whatupdave',
                              email: 'dave@minefold.com',
                           password: 'carlsmum',
              password_confirmation: 'carlsmum'}
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in dave
  end
  
  describe "create" do
    it "creates a world" do
      
      # lambda {
      #   post :create, world: { name:'jupiter' }
      # }.should change(World, :count).by(1)
      
      post :create, world: { name:'jupiter' }
      p request.env['warden']
      p request.env['warden.options']
      
      response.should redirect_to("/world/jupiter")
      
      # new_world = World.first
      # new_world.creator_slug.should == 'whatupdave'
    end
  end
end