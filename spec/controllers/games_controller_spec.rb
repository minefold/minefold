require 'spec_helper'

describe GamesController do

  describe "GET #show" do

    it "assigns the correct game" do
      get :show, id: 'minecraft'
      expect(controller.game).to eq(GAMES.find('minecraft'))
    end

    it "is successful" do
      get :show, id: 'minecraft'
      expect(response).to be_successful
    end

  end

end
