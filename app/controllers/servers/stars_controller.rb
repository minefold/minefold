class Servers::StarsController < ApplicationController
  respond_to :js

  prepend_before_filter :authenticate_user!

# --

  expose :server

# --

  def create
    authorize! :read, server
    server.stars << current_user

    render json: {count: server.stars.count}
  end

  def destroy
    authorize! :read, server
    server.stars.delete(current_user)

    render json: {count: server.stars.count}
  end

end
