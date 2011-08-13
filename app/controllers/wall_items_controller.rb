class WallItemsController < ApplicationController

  expose(:world) { World.find_by_slug!(params[:world_id] || params[:id]) }

  def create
    @chat = Chat.new(user: current_user, raw: params[:raw])
    world.wall_items << @chat

    if @chat.valid? and @chat.save
      @chat.send_message_to_world

      respond_to do |format|
        format.html { redirect_to world }
        format.json { render json: @chat.to_hash }
      end
    else
      render json: {errors: @chat.errors}
    end
  end

  def page
    render :json => world.wall_items.paginate(page: params[:page].to_i).map(&:to_hash)
  end

end
