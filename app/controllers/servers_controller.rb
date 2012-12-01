# TODO Move most of this logic into the Server model

class ServersController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, :except => [:show, :map]

# --

  expose(:server)

# --

  def index
    @servers = current_user.created_servers.group_by {|s| s.funpack.game }
  end

  def new
    authorize! :create, server

    @games = Game.all

    if params[:funpack].present?
      @funpack = Funpack.find(params[:funpack])
    end
  end

  def new_funpack_settings
    authorize! :create, server

    # server.set_default_settings

    @funpack = Funpack.find(params[:funpack_id])

    render layout: false
  end

  def create
    authorize! :create, server

    server.creator = current_user
    server.users << current_user
    server.save

    track 'Created server',
      name: server.name,
      url: server_url(server),
      shared: server.shared?,
      funpack: server.funpack.name,
      game: server.game.name

    respond_with(server)
  end

  def show
  end

  def map
    not_found unless server.funpack.game.minecraft?
  end

  def edit
    authorize! :update, server
  end

  def update
    authorize! :update, server
    server.update_attributes(params[:server])
    respond_with(server)
  end

  def start
    authorize! :update, server

    session = server.sessions.create

    PartyCloud.start_server(
      server.party_cloud_id,
      server.funpack.party_cloud_id,
      server.settings
    )

    if server.normal?
      Resque.enqueue_in(params[:ttl].to_i, StopServerJob, server.id)
    end

    respond_with(server)
  end

  def watch
    authorize! :read, server
    current_user.watch(server)

    track 'Watched server',
      name: server.name,
      url: server_url(server)

    respond_with(server)
  end

  def unwatch
    authorize! :read, server
    current_user.unwatch(server)
    respond_with(server)
  end


  def destroy
    authorize! :destroy, server

    if server.up?
      Resque.enqueue(StopServerJob, server.id)
    end

    server.destroy

    redirect_to(servers_path, notice: "Server \"#{server.name}\" was destroyed.")
  end

end
