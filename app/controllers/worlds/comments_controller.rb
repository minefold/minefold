class Worlds::CommentsController < ApplicationController
  respond_to :json, :html

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }
  expose(:creator) {
    player.user or raise NotFound
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

    (world.player_ids - [current_user.minecraft_player.id]).each do |player_id|
      player = MinecraftPlayer.find(player_id)
      if user = player.user
        if user.notify? :world_comment_added
          UserMailer
            .world_comment_added(user.id, world.id, comment.id)
            .deliver
        end
      end
    end


    respond_with world, location: player_world_path(player, world)
  end

end
