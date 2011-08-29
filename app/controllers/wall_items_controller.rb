class WallItemsController < ApplicationController

  expose(:world) { World.find_by_slug!(params[:world_id] || params[:id]) }

  def create
    chat = Chat.new(user: current_user, raw: params[:raw])

    if chat.valid?
      # TODO Check what callbacks this calls and fire media job
      world.push :wall_items, chat

      # TODO: Implement
      chat.wall.broadcast chat.raw

      respond_to do |format|
        format.json { render json: chat.to_hash }
      end
    else
      render json: {errors: chat.errors}
    end
  end

  statsd_count_success :create, 'WallItemsController.create'

  def page
    render :json => world.wall_items.paginate(page: params[:page].to_i).map(&:to_hash)
  end

end
