class WallItemsController < ApplicationController

  def create
    @world = World.find_by_slug!(params[:world_id])
    @chat = Chat.new(user: current_user, wall: @world, raw: params[:body])

    if @chat.valid? and @chat.save
      respond_to do |format|
        format.html { redirect_to @world }
        format.json { render json:@chat.to_hash }
      end
    else
      render json: {errors: @comment.errors}
    end
  end

end
