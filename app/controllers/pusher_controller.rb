class PusherController < ApplicationController
  class PusherNotAuthorized < StandardError; end

  # TODO Add the CSRF token to the JS lib so we don't have to work around this
  protect_from_forgery :except => :auth

  rescue_from PusherNotAuthorized, :with => :not_authorized
  rescue_from ActiveRecord::RecordNotFound, :with => :not_authorized

  def auth
    # Check that it's a nicely formed request
    unless signed_in? and params[:channel_name] and params[:socket_id]
      raise PusherNotAuthorized
    end

    # Fetch the object that the user wants to listen to
    _, model, id = params[:channel_name].split('-')
    resource = case model
    when 'user'
      User.find_by_id!(id)
    when 'server'
      Server.find_by_id!(id)
    else
      raise PusherNotAuthorized
    end

    # If a user can modify an object, they should get sensitive changes to it
    unless can?(:update, resource)
      raise PusherNotAuthorized
    end

    channel = Pusher[params[:channel_name]]
    response = channel.authenticate(params[:socket_id],
      user_id: current_user.id.to_s
    )

    render :json => response, :status => 200
  end

private

  def not_authorized
    render :text => "Not authorized", :status => 403
  end

end
