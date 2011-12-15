class Worlds::EventsController < ApplicationController

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
      
      # TODO Massive hack because representative sucks
      chat_data = {
        id: chat.id,
        created_at: chat.created_at,
        text: chat.text,
        source: {
          id: chat.source.id,
          url: url_for(chat.source),
          username: chat.source.username,
          avatar: chat.source.avatar.head.s24.url
        }
      }
      
      # TODO: Re-implement
      world.broadcast 'chat-create', chat_data, params[:socket_id]

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
