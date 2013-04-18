class FunpacksController < ApplicationController

  expose(:funpack) {
    Funpack.published.find(params[:id])
  }

end
