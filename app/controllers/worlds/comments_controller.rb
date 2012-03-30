class Worlds::CommentsController < ApplicationController
  respond_to :json, :html

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }
  expose(:creator) {
    player.user
  }
  expose(:world) {
    creator.created_worlds.find_by(slug: params[:world_id].downcase)
  }

  expose(:comment) {
    Comment.new params[:comment]
  }

  def create
    authorize! :play, world

    comment.author = current_user
    comment.commentable = world

    world.comments.push(comment)

    respond_with world, location: player_world_path(player, world)
  end

end
