class Servers::CommentsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!

# --

  expose :server

  expose :comments, :ancestor => :server
  expose :comment

# --

  def create
    authorize! :create, comment

    comment.author = current_user
    comment.save

    # TODO Add back in.
    # ServerMailer.comment(server.id, comment.id).deliver

    respond_with comment, location: server_path(server)
  end

end
