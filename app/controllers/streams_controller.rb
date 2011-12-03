class StreamsController < ApplicationController

  respond_to :json

  expose(:world) do
    World.find_by_slug!(params[:world_id])
  end

  def index
    World.stream
  end

end
