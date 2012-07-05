class PusherController < ApplicationController
  protect_from_forgery :except => :auth
  
  skip_before_filter :require_player_verification

  def auth
    if current_user
      response = Pusher[params[:channel_name]]
        .authenticate(params[:socket_id], {
          user_id: current_user.id.to_s
        })

      render :json => response
    else
      render :text => "Not authorized", :status => '403'
    end
  end
end 