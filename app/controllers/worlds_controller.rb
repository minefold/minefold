class WorldsController < ApplicationController

  prepend_before_filter :authenticate_user!, except: :show

  before_filter :lock_private, except: [:new, :create, :import, :import_policy]

  expose(:world) { World.find_by_slug(params[:id]) }

  def new
    # TODO Get working with Decent Exposure
    @world = World.new
  end

  def create
    @world = World.new(params[:world])
    @world.creator = current_user
    @world.players << current_user if @world.private?

    if @world.save
      current_user.world = @world
      if current_user.save
        redirect_to @world
      else
        render json: {errors: current_user.errors}
      end
    else
      render json: {errors: @world.errors}
    end
  end

  def show
    render :action => world.status unless world.status.blank?
  end

  def edit
    # @world = World.find_by_slug! params[:id]
  end

  def update
    world.update_attributes params[:world]

    if world.save
      redirect_to world
    else
      render json: {errors: world.errors}
    end
  end

  def map
    # world = World.find_by_slug! params[:id]
  end

  def activate
    current_user.world = world

    if current_user.save
      redirect_to :back
    else
      render json: {errors: current_user.errors}
    end
  end

  def import
    filename = [
      params[:world][:id],
      params[:world][:filename]
    ].join('-').gsub /[ !'"]/, '_'

    Resque.enqueue(Job::ImportWorld, params[:world][:id], filename)
    render nothing: true
  end

  def import_policy
    policy = S3UploadPolicy.new(ENV['S3_KEY'], ENV['S3_SECRET'], bucket(:world_import))
    policy.key = params[:key]
    policy.content_type = params[:contentType]

    render xml: policy.to_hash
  end

private

  def lock_private
    if world.private? and
       not (signed_in? and world.players.include?(current_user))
      raise MongoMapper::DocumentNotFound
    end
  end

end
