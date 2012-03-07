class Worlds::CommentsController < ApplicationController
  respond_to :json, :html

  expose(:creator) { User.find_by_slug! params[:user_id] }
  expose(:world) {
    World.find_by_creator_and_slug!(creator, params[:world_id])
  }

  expose(:comment) {
    Comment.new params[:comment]
  }

  def create
    authorize! :play, world

    comment.author = current_user
    comment.commentable = world

    world.comments.push(comment)
    world.save!

    respond_with world, location: user_world_path(creator, world)
  end

end
