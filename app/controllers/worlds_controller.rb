class WorldsController < ApplicationController

  def new
    @world = World.new
  end

  def create
    world = World.new params[:world]
    world.admins << current_user
    world.save!

    redirect_to "/#{world.slug}"
  end

  def show
    @world = World.find_by_slug! params[:id]

    render :action => @world.status unless @world.status.blank?
  end

  def activate
    @world = World.first :slug => params[:id]

    current_user.set world_id: @world.id

    redirect_to @world
  end

  def post
    @world = World.first :slug => params[:id]

    @world.wall_items << Post.create(user: user, message: params[:post][:message])
    @world.save

    redirect_to @world
  end

end
