require 'spec_helper'

describe GiftsController do

  describe "GET #index" do
    it "assigns credit packs" do
      packs = 3.times.map { CoinPack.make! }.sort_by {|p| p.cents }
      get :index
      assigns(:packs).should eq(packs)
    end

    it "is successful" do
      get :index
      expect(response).to be_successful
    end
  end


  describe "#create" do
  end

end
