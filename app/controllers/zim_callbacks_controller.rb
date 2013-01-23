class ZimCallbacksController < ApplicationController
  respond_to :json

  def map_deleted
    data = JSON.parse(request.body.read)

    if @server = Server.unscoped.find(data['id'])
      @server.world.destroy
    end

    render nothing: true, :status => :ok
  end
end
