class WorldsController < ApplicationController

  prepend_before_filter :authenticate_user!, except: [:index, :show, :map]

  # before_filter :lock_private, only: [:show, :edit, :update, :map, :photos, :activate]

  expose(:creator) { User.find_by_slug!(params[:creator_id])}

  expose(:worlds)
  expose(:world) { params[:id] ? World.find_by_slug!(params[:id]) : World.new(params[:world]) }

  def index
    @main = World.find_by_slug 'midgard'
    @suba = World.find_by_slug 'atlassian'
    @subb = World.find_by_slug 'minefold'
    @subc = World.find_by_slug 'minefold'
  end

  def create
    raise "sup?"
    world.creator = current_user
    world.players << current_user unless world.public?

    if world.save
      current_user.current_world = world
      current_user.save
      redirect_to world
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    world.update_attributes params[:world]

    world.players << current_user

    if world.save
      redirect_to world
    else
      render json: {errors: world.errors}
    end
  end

  def map
  end

  def photos
  end

  def play
    current_user.world = world

    if current_user.save
      redirect_to :back
    else
      render json: {errors: current_user.errors}
    end
  end

  def play_request
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

protected

  statsd_count_success :create, 'WorldsController.create'
  statsd_count_success :show, 'WorldsController.show'
  statsd_count_success :update, 'WorldsController.update'
  statsd_count_success :map, 'WorldsController.map'
  statsd_count_success :photos, 'WorldsController.photos'
  statsd_count_success :play, 'WorldsController.play'
  statsd_count_success :play_request, 'WorldsController.play_request'

private

  def lock_private
    if not world.public? and
       not (signed_in? and current_user.staff?) and
       not (signed_in? and world.players.include?(current_user))
      raise Mongoid::Errors::DocumentNotFound
    end
  end

end
