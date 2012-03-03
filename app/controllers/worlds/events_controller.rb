class Worlds::EventsController < ApplicationController
  layout nil

  expose(:creator) { User.find_by_slug! params[:user_id] }
  expose(:world) { World.find_by_slug!(creator.id, params[:world_id]) }
  respond_to :json

  def index
    authorize! :read, world
  end

  # def create
  #   authorize! :chat, world
  #
  #   chat = world.record_event! Chat, source: current_user,
  #                                    text: params[:text]
  #
  #   if chat.valid?
  #     world.broadcast "#{chat.pusher_key}-created",
  #                     chat.attributes,
  #                     params[:socket_id]
  #
  #     world.say chat.msg
  #   end
  #
  #   respond_with chat, location: world_events_path(world)
  # end

end
