class WorldsController < ApplicationController

  prepend_before_filter :authenticate_user!, except: [:index, :show, :map]

  expose(:user) { User.find_by_slug!(params[:user_id])}

  expose(:worlds)
  expose(:world) do
    user.owned_worlds.find_by_slug!(params[:id])
  end

  def index
  end

  def new
    @world = World.new
    @world.creator = current_user
  end

  def create
    @world = World.new(params[:world])

    world.creator = current_user
    world.owner = current_user

    if world.save
      current_user.current_world = world
      current_user.save
      redirect_to user_world_path(world.owner, world)
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json:world }
    end
  end

  def edit
  end

  def update
    world.update_attributes params[:world]
    if world.save
      flash[:success] = "Settings successfully updated."
      redirect_to params['return_url'] || user_world_path(world.owner, world)
    else
      render json: {errors: world.errors}
    end
  end

  def map
  end

  def photos
  end

  def play
    if world.public? or world.whitelisted?(current_user)
      current_user.current_world = world
      current_user.save

      redirect_to :back
    end
  end

  def play_request
    WorldMailer.play_request(world.id,
                             world.owner.id,
                             current_user.id).deliver
    flash[:success] = 'Play request sent'
    redirect_to user_world_path(world.owner, world)
  end


  def process_upload
    upload = WorldUpload.create s3_key:params[:key],
                              filename:params[:name],
                              uploader:current_user

    Resque.enqueue ImportWorldJob, upload.id
    render json: { world_upload_id:upload.id }
  end

  def upload_policy
    @policy = S3UploadPolicy.new(ENV['S3_KEY'], ENV['S3_SECRET'], bucket(:world_import))
    @policy.key = params[:key]
    @policy.content_type = params[:contentType]

    render layout:false
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

  def bucket path
    "minefold.#{Rails.env}.worlds-to-import"
  end

end
