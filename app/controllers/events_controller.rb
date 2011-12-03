class EventsController < ApplicationController

  expose(:world) { World.find_by_slug!(params[:world_id]) }

  respond_to :json
  layout nil

  def index
  end

  # TODO: Smell, needs to be renamed
  def create
    chat = Chat.new(
      source: current_user,
      target: world,
      text: params[:text]
    )

    if chat.valid?
      world.events.push(chat)

      # chat.wall.broadcast 'chat-create',
      #                     chat.to_json(include: :user),
      #                     params[:socket_id]

      # chat.wall.say chat.msg

      respond_to do |format|
        format.json { render json: chat.attributes }
      end
    else
      render json: {errors: chat.errors}
    end
  end

  def page
    render :json => world.wall_items.paginate(page: params[:page].to_i).map(&:to_hash)
  end

end
