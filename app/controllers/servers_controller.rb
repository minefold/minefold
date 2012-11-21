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

    # TODO Stub

    track 'Started server',
      name: server.name,
      url: server_url(server)

    respond_with(server)
  end

  def extend
    authorize! :update, server

    # TODO Stub

    track 'Extended server',
      name: server.name,
      url: server_url(server)

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

    server.destroy

    redirect_to(servers_path, notice: "Server \"#{server.name}\" was destroyed.")
  end

end
