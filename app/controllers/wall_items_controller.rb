class WallItemsController < ApplicationController
  
  expose(:world) { World.find_by_slug!(params[:world_id]) }

  def create
    @world = world
    @chat = Chat.new(user: current_user, wall: @world, raw: params[:body])

    if @chat.valid? and @chat.save
      @chat.send_message_to_world
      
      respond_to do |format|
        format.html { redirect_to @world }
        format.json { render json:@chat.to_hash }
      end
    else
      render json: {errors: @comment.errors}
    end
  end
  
  def page
    @wall_items = WallItem.where(wall_id:world.id).paginate(order: :created_at.desc, per_page:25, page:params[:page].to_i)
    
    render :json => @wall_items.map(&:to_hash)
  end

end
