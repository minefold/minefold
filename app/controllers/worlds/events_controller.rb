class Worlds::EventsController < ApplicationController
  layout nil
  
  expose(:world) { World.find_by_slug!(params[:world_id]) }
  respond_to :json

  def index
  end

  def create
    chat = world.record_event! Chat, source: current_user,
                                     text: params[:text]
    
    if chat.valid?
      world.broadcast "#{event.pusher_key}-created",
                      chat.attributes,
                      params[:socket_id]

      world.say chat.msg
    end
    respond_with chat
  end

end
