class WallItemsController < ApplicationController

  expose(:world) { World.find_by_slug!(params[:world_id] || params[:id]) }

  def create
    chat = Chat.new(params[:chat])
    chat.user = current_user

    if chat.valid?
      # TODO Check what callbacks this calls and fire media job
      world.wall_items.push chat

      chat.wall.broadcast 'chat-create',
                          chat.to_json(include: :user),
                          params[:socket_id]

      chat.wall.say chat.msg

      respond_to do |format|
        format.json { render json: chat.attributes }
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
