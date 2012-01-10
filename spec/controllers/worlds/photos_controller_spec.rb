require 'spec_helper'

describe Worlds::PhotosController do
  let(:world) {create :world}

  describe '#create' do
    context 'not signed in' do
      it "is unauthorized" do
        post :create, world_id: world.slug
        response.status.should == 401
      end
    end
  end
end
