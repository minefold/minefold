class ZimCallbacksController < ApplicationController
  respond_to :json
  
  skip_before_filter  :verify_authenticity_token

  def map_deleted
    data = JSON.parse(request.body.read)

    if @server = Server.unscoped.find(data['id'])
      @server.world.destroy if @server.world
    end

    render nothing: true, :status => :ok
  end
end
