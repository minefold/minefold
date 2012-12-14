class Servers::PostsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!

# --

  expose :server

  expose :posts, :ancestor => :server
  expose :post

# --

  def create
    authorize! :create, post

    post.author = current_user
    post.save

    # TODO Add back in.
    # ServerMailer.comment(server.id, comment.id).deliver

    respond_with post, location: server_path(server)
  end

end
