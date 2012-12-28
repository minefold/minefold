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
    if $flipper[:next].enabled?(current_user)
      render :next, layout: 'next'
    end
  end

  def map
    not_found unless server.funpack.game.minecraft?
  end

  def edit
    authorize! :update, server
  end

  def update
    authorize! :update, server

    # TODO Actual error checking here!
    server.update_attributes(params[:server])

    if params[:server][:force].present?
      PartyCloud.stop_server(sever.party_cloud_id)
    end

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

    respond_with(server)
  end

  def stop
    authorize! :update, server
    PartyCloud.stop_server(server.party_cloud_id)
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
