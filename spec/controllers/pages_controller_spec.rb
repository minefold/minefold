require 'spec_helper'

describe PagesController do

  describe "GET #home" do

    it "assigns games" do
      get :home
      expect(assigns(:games)).to eq(GAMES)
    end

  end

end
