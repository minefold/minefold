class Servers::WatchersController < ApplicationController
  respond_to :html, :js

  prepend_before_filter :authenticate_user!

# --

  expose :server

# --

  def create
    authorize! :read, server
    server.watchers << current_user

    render json: {count: server.watchers.count}
  end

  def destroy
    authorize! :read, server
    server.watchers.delete(current_user)

    render json: {count: server.watchers.count}
  end

end
