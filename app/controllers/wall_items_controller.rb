class WallItemsController < ApplicationController

  def create
    @world = World.find_by_slug!(params[:world_id])
    @chat = Chat.new(user: current_user, wall: @world, body: params[:body])

    if @chat.valid? and @chat.save
      redirect_to @world
    else
      render json: {errors: @comment.errors}
    end
  end

end
