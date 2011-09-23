class PhotosController < ApplicationController
  prepend_before_filter :authenticate_user!

  expose(:user) { User.find_by_slug!(params[:user_id])}
  expose(:world) do
    user.owned_worlds.find_by_slug!(params[:id])
  end

  def index
  end

end
