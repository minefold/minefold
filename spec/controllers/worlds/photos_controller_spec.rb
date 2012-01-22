require 'spec_helper'

describe Worlds::PhotosController do
  let(:world) { Fabricate(:world) }

  describe '#create' do
    context 'not signed in' do
      it "is unauthorized" do
        post :create, user_id: world.creator.slug, world_id: world.slug
        response.status.should == 401
      end
    end
  end
end
