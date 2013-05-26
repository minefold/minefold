class FunpacksController < ApplicationController
  respond_to :html

  expose(:funpack) {
    Funpack.published.find(params[:id])
  }

  def show
  end

  def edit
    if not (signed_in? and current_user.admin?)
      not_found
    end
  end

  def update
    if not (signed_in? and current_user.admin?)
      not_found
    end

    funpack.update_attributes(params[:funpack])
    respond_with(funpack)
  end

end
