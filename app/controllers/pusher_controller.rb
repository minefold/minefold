class PusherController < ApplicationController
  protect_from_forgery :except => :auth

  def auth
    if signed_in?
      channel = Pusher[params[:channel_name]]

      response = channel.authenticate params[:socket_id],
        user_id: current_user.id.to_s

      render :json => response, :status => 200
    else
      render :text => "Not authorized", :status => 403
    end
  end

end