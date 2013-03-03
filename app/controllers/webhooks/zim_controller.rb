class Webhooks::ZimController < ApplicationController
  protect_from_forgery :except => :process

  def create
    Librato.increment('webhook.zim.total')

    data = JSON.parse(request.body.read)

    pg_id = Integer(data['id']) rescue nil

    if pg_id
      if @server = Server.unscoped.find_by_id(pg_id)
        @server.world.destroy if @server.world
      end
    end

    render nothing: true, :status => :ok
  end

end
