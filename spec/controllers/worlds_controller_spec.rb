require 'spec_helper'

describe WorldsController do
  let(:user) { User.create username: 'whatupdave',
                              email: 'dave@minefold.com',
                           password: 'carlsmum',
              password_confirmation: 'carlsmum'}
  before do
    sign_in user
  end
  
  context "create" do
    it "should set creator slug" do
      post 'create', world: { name:'jupiter' }

      new_world = World.find_by_slug 'jupiter'
      new_world.creator_slug.should == 'whatupdave'
    end
  end
end